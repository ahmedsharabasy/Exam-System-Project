


create proc add_new_question_mcq (
    @ins_id int,
    @password varchar(50),
    @q_id int,
    @course_id int,
    @question varchar(max),
    @question_type varchar(max),
    @question_degree int,
    @choice1 varchar(50),
    @choice2 varchar(50),
    @choice3 varchar(50),
    @choice4 varchar(50),
    @correct_answer varchar(50)
)
as
begin
    if exists (select 1 from log_account where id = @ins_id and type = 'i' and password = @password) 
    begin
        insert into [dbo].[Questions] (q_id, c_id, [type], question, q_degree)
        values (@q_id, @course_id, @question_type, @question, @question_degree);

        insert into [dbo].[question_choices] (Choice_Text, Is_Correct, Qus_No)
        values (@choice1, case when @choice1 = @correct_answer then 1 else 0 end, @q_id),
               (@choice2, case when @choice2 = @correct_answer then 1 else 0 end, @q_id),
               (@choice3, case when @choice3 = @correct_answer then 1 else 0 end, @q_id),
               (@choice4, case when @choice4 = @correct_answer then 1 else 0 end, @q_id);
			   
    end
    else
    begin
        print ('Invalid credentials.');
    end
    
    return
end


exec add_new_question_mcq 3, '111', 307, 1, 'What is Hadoop?', 'mcq', 10, 'A', 'B', 'C', 'D', 'A';

-------------------------------------------------------
create proc add_new_question_True_and_false (
    @ins_id int,
    @password varchar(50),
    @q_id int,
    @course_id int,
    @question varchar(max),
    @question_type varchar(max),
    @question_degree int,
    @correct_answer varchar(50)
)
as
begin
    if exists (select 1 from log_account where id = @ins_id and type = 'i' and password = @password) 
    begin
        insert into [dbo].[Questions] (q_id, c_id, [type], question, q_degree)
        values (@q_id, @course_id, @question_type, @question, @question_degree);

        insert into [dbo].[question_choices] (Choice_Text, Is_Correct, Qus_No)
        values ('true', case when @correct_answer = 'true' then 1 else 0 end, @q_id),
			   ('false', case when @correct_answer = 'false' then 1 else 0 end, @q_id)
			   
    end
    else
    begin
        print ('Invalid credentials.');
    end
    
    return
end

--test
select * from  question_choices
where Qus_No = 305

exec add_new_question_True_and_false 3, '111', 308, 1, 'Sub classes may also be called Child classes/Derived classes?', 't/f', 10, 'true';


---------------------------------------------------------------------

alter procedure update_question_mcq (
    @ins_id int,
    @password varchar(50),
    @q_id int, 
    @indicator int,
    @correction varchar(max)
)
as
begin
    declare @current_date datetime = getdate()

    declare @start_time datetime
    declare @end_time datetime

    select @start_time = start_time, @end_time = end_time 
    from exam 
    where exam_id = (select exam_id from exam_question where q_id = @q_id)
	
    if @password = (select password from log_account where id = @ins_id and type = 'i') 
    begin
        if @q_id in (select q_id from exam_question) and @current_date between @start_time and @end_time
        begin
            select 'you cannot update this question at this time' as error
        end
        else
        begin
            if @indicator = 1
            begin
                update questions 
                set question = @correction
                where q_id = @q_id
            end
            else if @indicator = 2
            begin 
                update questions 
                set type = @correction
                where q_id = @q_id
            end
            else if @indicator = 3
            begin 
                update questions 
                set q_degree = @correction
                where q_id = @q_id
            end
            else if @indicator = 4
            begin 
                update question_choices
                set choice_text = @correction
                where Qus_No = @q_id and is_correct = 1
            end
            else
            begin
                print 'error'
            end
        end
    end
    else
    begin
        select 'you do not have permission to do this update'
    end;
end;


exec update_question_mcq 3, '111', 304, 3, 10

-------------------------------------

alter procedure [dbo].[delete_question] (
@ins_id int,
@password varchar(50),
@Q_id int 
)
as
begin
	declare @current_date datetime = getdate();

    declare @start_time datetime;
    declare @end_time datetime;

    select @start_time = start_time, @end_time = end_time 
    from exam 
    where exam_id = (select Exam_id from Exam_Question where Q_ID = @Q_id);
	
	if @password = (select password from log_account where id = @ins_id and type = 'i') 
		begin
			if @Q_id in (select Q_ID from Exam_Question) and @current_date between @start_time and @end_time
				begin
					select 'you can not delete this question at this time' as error
				end
			else
				begin
					delete from [dbo].[question_choices]
					where Qus_No = @Q_id;

					delete from [dbo].[questions]
					where Q_id = @Q_id;

				end
		end
	else
		begin
			select 'you do not have a permssion to do this update'
		end
end


exec delete_question 3 , 111 , 217


