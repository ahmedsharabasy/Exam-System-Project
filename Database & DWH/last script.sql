CREATE PROCEDURE [dbo].[Inserttrack](
	@Track_name nvarchar(20))
AS
BEGIN
    INSERT INTO [dbo].[Track]([Track_name])
	VALUES(@Track_name)
END

--test
exec [dbo].[Inserttrack] 'UI/UX'

-------------------------------------------------------------

CREATE PROCEDURE [dbo].[Inserttrainingmanager](
	@manager_name nvarchar(30),
	@branch_id int)
AS
BEGIN
    INSERT INTO [dbo].[Training_manager]([mgr_name],[Branch_id])
	VALUES( @manager_name,@branch_id) 
END

--test
exec [Inserttrainingmanager] 'Adel Adel' , 8

----------------------------------------------------------------------------------------------------------------------

alter procedure [dbo].[random_question] (@exam_id int, @number_of_question int)
as 
begin 
    insert into exam_question (exam_id, q_id)
    select top (@number_of_question) @exam_id, q.q_id
    from questions q
    where q.c_id = (select c_id from exam where exam_id = @exam_id)
    and not exists (
        select 1
        from exam_question eq
        where eq.exam_id = @exam_id
        and eq.q_id = q.q_id
    )
    order by newid();
end

--run 
--test

--------------------------------------------------------
alter procedure [dbo].[show_student_exams] (@student_id int, @password varchar(50))
as
begin
	if @password = (select password from log_account where id = @student_id and type = 's')
		begin
			select c.[course_name] as Exam_name , e.start_time , e.end_time  from Pick_Exam px , exam e , [dbo].[courses] c
			where px.EXam_ID = e.Exam_id and px.C_id = c.[course_id] and px.St_ID =@student_id
		end
	else 
	begin
		select 'You can view your exams only ' as error
	end
end

--run ,but not tested 
--test
exec [show_student_exams] 3, 111




-------------------------------------------------------------
create procedure [dbo].[update_exam] (@e_id int, @new_start_time datetime, @new_end_time datetime)
as
begin
    update [dbo].[Exam]
    set start_time = @new_start_time,
        end_time = @new_end_time
    where exam_id = @e_id;
end;

--run ,but not tested
--test
exec [update_exam] 



---------------------------------------------------------
create procedure [dbo].[update_exam_question] (@e_id int, @old_q_id int, @new_q_id int)
as
begin
    update [dbo].[Exam_Question]
    set Q_ID = @new_q_id
    where Exam_id = @e_id and Q_ID = @old_q_id;
end;


--run , but not tested
--test
exec [update_exam_question] 



-------------------------------------------------------------
alter proc [dbo].[update_intake] (@old_intake_num nvarchar(50), @new_intake_num nvarchar(50), @t_manager_id int, @t_manager_password varchar(20) )
as 
begin
    if exists (select 1 from Log_Account  
			   where id = @t_manager_id and password =@t_manager_password and type = 't'
	)
	begin
	update 	[dbo].[Intake]
	set [Intake_num] = @new_intake_num
	where [Intake_num] = @old_intake_num 
		end

	else
	begin
		print 'you dont have permission'
	end
end

--test
exec [update_intake] 'Intake32_Round3', 'Intake32_Round90' , 5, '111'

exec [update_intake] 'Intake32_Round90', 'Intake32_Round3' , 5, '111'


-----------------------------------------------------------
 ----------------------------------------------------------------------
CREATE PROCEDURE [dbo].[updatetrack](
    @Track_id int,
	@Track_name nvarchar(20)
)
AS
BEGIN
    UPDATE [dbo].[Track]
    SET [Track_name] = @Track_name
    WHERE [Track_id] = @Track_id;
END


exec [updatetrack] 1, 'project management'
exec [updatetrack] 1, 'BI'

------------------------------------------------------------------
create PROCEDURE [dbo].[updatetrackcourse](
    @Track_id int,
	@course_id int,
	@new_course_id int
)
AS
BEGIN
    UPDATE [dbo].[Track_Course]
    SET [C_ID] = @new_course_id
    WHERE [Track_id] = @Track_id and [C_ID] = @course_id ;
END

--test
exec [updatetrackcourse]  1, 1, 2
exec [updatetrackcourse]  1, 2, 1

-----------------------------------------------

CREATE PROCEDURE [dbo].[update_trainingmanager](
    @manager_id int,
	@manager_name nvarchar(30),
	@branch_id int
)
AS
BEGIN
    UPDATE [dbo].[Training_manager]
    SET [mgr_name] = @manager_name,
	[Branch_id] = @branch_id
    WHERE [manager_id] = @manager_id ;
END


--test
exec [update_trainingmanager] 1, 'Samy Soliman', 1 


--------------------------------------------------

create procedure [dbo].[get_questions] (@Course_name varchar(50))
as 
begin
	select Q.Q_id ,Q.question , Q.type , Q.Q_degree 
	from [dbo].[questions] Q , [dbo].[courses] C
	where Q.C_id = C.[course_id] and C.[course_name] = @Course_name
end


--test
exec [get_questions] 'OOP'




------------------------------------------

alter proc [dbo].[update_Branch_track] (@Bran_ID int, @Track_ID int, @new_Track_ID int , @t_manager_id int, @t_manager_password varchar(20))
as
begin
    if exists (select 1 from Log_Account  
			   where id = @t_manager_id and password =@t_manager_password and type = 't'
	)
	begin
		update [dbo].[Branch_track]
		set Track_ID = @new_Track_ID
		where Bran_ID = @Bran_ID and [Track_ID] = @Track_ID
	end
	else
	begin
		print 'you do not have permission'
	end
end


--test
exec [update_Branch_track] 1, 1,5, 5, '111'

exec [update_Branch_track] 1, 5,1, 5, '111'

-------------------------------------------------------------------


alter procedure [dbo].[update_courses] (
@c_id int , 
@indicator int,
@correction varchar(max),
@Tran_id int,
@password varchar(20)
)
as
begin
	if @password = (select password from log_account where id = @Tran_id and type = 't') 
		begin
			if @indicator = 1
				begin 
					update [dbo].[courses]
					set [course_name] = @correction
					where [course_id] = @c_id
				end
			else if @indicator = 2
				begin 
					update [dbo].[courses]
					set [max_degree] = @correction
					where [course_id] = @c_id
				end
			else if @indicator = 3
				begin 
					update [dbo].[courses]
					set [min_degree] = @correction
					where [course_id] = @c_id
				end
			else 
				begin
					update [dbo].[courses]
					set [dept_id] = @correction
					where [course_id] = @c_id
				end
		end
	else
		begin
			select 'you do not have permission'
		end
end

--test
exec [update_courses] 1, 1, 'OOPpppp', 5, '111'

exec [update_courses] 1, 1, 'OOP', 5, '111'

--------------------------------------------------------------------------------------

alter proc [dbo].[update_department] (@old_department_name varchar(20), @new_department_name varchar(20), @Tran_id int, @password varchar(20) )
as 
begin
    if @password = (select password from log_account where id = @Tran_id and type = 't') 
	begin
	update 	[dbo].[Department]
	set [dept_name] = @new_department_name
	where [dept_name] = @old_department_name

		end
	else
	begin
		print 'you dont have permission'
	end
end


--test
exec [update_department] 'Software Development' , 'coding', 5, '111'

exec [update_department] 'coding', 'Software Development' , 5, '111'


------------------------------------------------------------------------------
alter proc [dbo].[update_ins_course] (
	   @new_Ins_id int
	  ,@old_Ins_id int
	  ,@new_C_id int
	  ,@old_C_id int
	  ,@Tran_id int
	  ,@password Varchar(20))
as
begin
    if @password = (select password from log_account where id = @Tran_id and type = 't') 

	begin

			update [dbo].[Ins_course]
			set C_id = @new_C_id , Ins_id = @new_Ins_id
			where C_id = @old_C_id and Ins_id = @old_Ins_id
	end
	else
	begin
		print 'you dont have permission'
	end
end


--test
exec [update_ins_course] 1,1 ,15, 4, 5, '111'

exec [update_ins_course] 1,1 ,4, 15, 5, '111'


-------------------------------------------------------------
create procedure [dbo].[update_instructors] (
@Ins_id int , 
@indicator int,
@correction varchar(max)
)
as
begin
			if @indicator = 1
				begin 
					update [dbo].[instructors]
					set [ins_name] = @correction
					where Ins_id = @Ins_id
				end
			else if @indicator = 2
				begin 
					update [dbo].[instructors]
					set [ins_age] = @correction
					where Ins_id = @Ins_id
				end
			else if @indicator = 3
				begin 
					update [dbo].[instructors]
					set [ins_gender] = @correction
					where Ins_id = @Ins_id
				end
			else if @indicator = 4
				begin 
					update [dbo].[instructors]
					set [ins_email] = @correction
					where Ins_id = @Ins_id
				end
			else if @indicator = 5
				begin 
					update [dbo].[instructors]
					set [salary] = @correction
					where Ins_id = @Ins_id
				end
			else 
				begin
					update [dbo].[instructors]
					set [city] = @correction
					where Ins_id = @Ins_id

		end
end

---------------------------------------------------------------------


alter procedure [dbo].[update_student] (
@St_id int , 
@indicator int,
@correction varchar(max),
@Tran_id int,
@password varchar(20)
)
as
begin
	if @password = (select password from log_account where id = @Tran_id and type = 't') 
		begin
			if @indicator = 1
				begin 
					update [dbo].[students]
					set [St_name] = @correction
					where St_id = @St_id
				end
			else if @indicator = 2
				begin 
					update [dbo].[students]
					set [email] = @correction
					where St_id = @St_id
				end
			else if @indicator = 3
				begin 
					update [dbo].[students]
					set [city] = @correction
					where St_id = @St_id
				end
			else if @indicator = 4
				begin 
					update [dbo].[students]
					set [st_gender] = @correction
					where St_id = @St_id
				end
			else if @indicator = 5
				begin 
					update [dbo].[students]
					set [st_age] = @correction
					where St_id = @St_id
				end
			else 
				begin
					update [dbo].[students]
					set [graduation_year] = @correction
					where St_id = @St_id
				end
		end
	else
		begin
			select 'you do not have permission'
		end
end


--test
exec [update_student] 1, 5, 25, 5, '111'


------------------------------------------------------------------------------

--edited
create function [dbo].[calaculate_degrees] ()
returns @T table (
st_id int,
total_degree int,
C_id int
)
as
begin
	insert into @T 
    select A.st_id, SUM(Q.Q_degree) AS total_degree , c.course_id
    from [dbo].[questions] Q, [dbo].[question_choices] QC, [dbo].[student_answers] A  , [dbo].[courses] C
    where Q.q_id = QC.Qus_No and A.answer = QC.Choice_Text and QC.Is_Correct = 1
	and Q.Q_id = A.Q_id and c.course_id = (select distinct PE.c_id from Pick_Exam PE, student_answers A where PE.Exam_id = A.e_id) 
    group by A.st_id, C.course_id
	return
end

--run
--not tested yet


select * from [calaculate_degrees]()







insert into student_answers
values(1,1,1,' Alan Kay')





-----------------------------------------------------------------
--
alter function [dbo].[exam_info] (@course_id int)
returns @t table (
course_name nvarchar(50),
Exam_type nvarchar(50),
track nvarchar(50),
branch nvarchar(50),
intake nvarchar(50) ,
star_time time ,
end_time time ,
total_time int
)
as 
begin
	insert into @t	
	select  C.course_name , E.type , T.Track_name , b.Branch , I.Intake_num , E.start_time , E.end_time , E.duration
	from  [dbo].[courses] C ,Track_Course TC , Track T , Branch_track BT ,Branch B ,  Branch_Intake BI, Intake I , Exam E , Pick_Exam PE
	where C.course_id = tc.C_ID and TC.Track_ID = t.Track_id  
	and T.Track_id = BT.Track_ID and BT.Bran_ID = b.id 
	and b.id = BI.Bran_ID and BI.Intake_ID = I.Intake_id  
	and C.course_id =PE.C_ID and E.Exam_id = PE.EXam_ID 
	and  C.course_id = @course_id
	return
end


--run
--not tested
select * from [exam_info] (1)


-----------------------------------------------------------
---- function get max degree for course to add check constriant to check total degree of course before insertion

alter FUNCTION [dbo].[GetMaxDegreeForCourse](@C_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @MaxDegree INT;
    
    SELECT @MaxDegree = max_degree
    FROM [dbo].[courses]
    WHERE course_id = @C_id;
    
    RETURN @MaxDegree;
END;



------------------------------------------------------------
--finish
alter view [dbo].[student_grade]
as
	select S.St_name as [student name] , C.course_name as [course name], sc.grade [grade] , case 
												when Sc.grade > C.min_degree then 'successed'
												else 'Faild'
												end as [status]
	from [dbo].[students] S , courses C , st_course SC
	where S.St_id = SC.st_id and SC.C_id = C.course_id
GO
-----------------------------------------------------------------------------------

----finish

alter proc [dbo].[add_branch] (@branch_city nvarchar(max), @t_manager_id int, @t_manager_password varchar(20))
as
begin
    if exists (select 1 from Log_Account a 
			   where a.id = @t_manager_id and a.password =@t_manager_password and a.type = 't'
	)
	begin
	insert into [dbo].[Branch]
	values (@branch_city)
	end
	else
	begin
		print 'you dont have permission'
	end
end


--test
exec [add_branch] Damietta , 5, '111'


-----------------------------------------------------------------------------
--finish
alter proc [dbo].[add_Branch_Dept] (@Bran_ID int, @Dept_ID int, @t_manager_id int, @t_manager_password varchar(20))
as
begin
    if exists (select 1 from Log_Account a 
			   where a.id = @t_manager_id and a.password =@t_manager_password and a.type = 't'
	)
	begin
		insert into [dbo].[Branch_Dept]
		values( @Bran_ID , @Dept_ID)
	end
	else
	begin
		print 'you do not have permission'
	end
end


--test
exec [add_Branch_Dept] 7,3 , 5, '111'


-----------------------------------------------------------------------

--finish
alter proc [dbo].[add_Branch_intake] (@Bran_ID int, @Intake_ID int, @t_manager_id int, @t_manager_password varchar(20))
as
begin
    if exists (select 1 from Log_Account a 
			   where a.id = @t_manager_id and a.password =@t_manager_password and a.type = 't'
	)
	begin
		insert into [dbo].[Branch_Intake]
		values( @Bran_ID , @Intake_ID)
	end
	else
	begin
		print 'you do not have permission'
	end
end


--test
exec [add_Branch_intake] 1, 38, 5, '111'



-------------------------------------------------------------------------------

--finish
alter proc [dbo].[add_Branch_track] (@Bran_ID int, @Track_ID int, @t_manager_id int, @t_manager_password varchar(20))
as
begin
    if exists (select 1 from Log_Account a 
			   where a.id = @t_manager_id and a.password =@t_manager_password and a.type = 't'
	)
	begin
		insert into [dbo].[Branch_track]
		values( @Bran_ID , @Track_ID)
	end
	else
	begin
		print 'you do not have permission'
	end
end


--test
exec [add_Branch_track] 1,10, 5, '111'



-------------------------------------------------------------------
--finish
alter proc [dbo].[add_course] (
	   @C_name Varchar(20)
      ,@max_degree int
      ,@min_degree int
      ,@dept_id int
	  ,@Tran_id int
	  ,@password Varchar(20))
as
begin
	if @password = (select password from log_account where id = @Tran_id and type = 't') 
	begin
		if not exists (select 1 from [dbo].courses where course_name = @C_name) 
		begin
			insert into [dbo].courses
			values (@C_name,  @max_degree, @min_degree, @dept_id);
		end
		else
		begin
			print 'this course is already exists'
		end
	end
	else
	begin
		print 'you dont have permission'
	end
end

--test
exec [add_course] 'ui', 100,50,5,5, '111'



-------------------------------------------------------------------------
--finish
alter proc [dbo].[add_department] (
	  @dept_name Varchar(20)
	  ,@Tran_id int
	  ,@password Varchar(20))
as
begin
    if @password = (select password from log_account where id = @Tran_id and type = 't') 
	begin
		if not exists (select 1 from [dbo].[Department] where [dept_name] = @dept_name) 
		begin
			insert into [dbo].[Department]
			values (@dept_name);
		end
		else
		begin
			print 'this department is already exists'
		end
	end
	else
	begin
		print 'you dont have permission'
	end
end


--test 
exec [add_department] 'data', 5, '111' 

---------------------------------------------------------
--finish
alter proc [dbo].[add_ins_course] (
	   @Ins_id int
	  ,@C_id int
	  ,@Tran_id int
	  ,@password Varchar(20))
as
begin
    if @password = (select password from log_account where id = @Tran_id and type = 't') 
	begin

			insert into [dbo].[Ins_course]
			values (@Ins_id, @C_id);
	end
	else
	begin
		print 'you dont have permission'
	end
end


--test
exec [add_ins_course] 1,15,5, '111'



-----------------------------------------------------------------------
--finish
alter proc [dbo].[add_instructor] (
       @Ins_name Varchar(20)
      ,@Gender Varchar(20)
      ,@Ins_address Varchar(20)
      ,@Ins_Email Varchar(20)
      ,@Ins_age int
	  ,@salary int)
as
begin
		if not exists (select 1 from [dbo].[Instructors] where [Ins_name] = @Ins_name) 
		begin
			insert into [dbo].[Instructors]
			values (
	   @Ins_name 
	  ,@Ins_age 
      ,@Gender 
      ,@Ins_Email 
	  ,@salary
      ,@Ins_address
	  );
		end
		else
		begin
			print 'this instructor is already exists'
		end
end

--test 

exec [add_instructor] 'kkkkk', 'Male', 'damietta', 'kkkk@',50, 50000



------------------------------------------------


alter proc [dbo].[add_intake] (@intake_num varchar(20), @t_manager_id int, @t_manager_password varchar(20))
as
begin
    if exists (select 1 from Log_Account a 
			   where a.id = @t_manager_id and a.password =@t_manager_password and a.type = 't'
	)
	begin
		if not exists (select 1 from [intake] where intake_num = @intake_num) 
		begin
			insert into [Intake]
			values (@intake_num);
		end
		else
		begin
		    print 'this intake is already exists'
		end
	end
	else
	begin
		print 'you dont have permission'
	end
end

--test
exec [add_intake] 'Intake355_Round3', 5, '111'






---------------------------------------------------------
alter proc add_new_question (
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


--test
exec add_new_question 3, '111', 301, 1, 'What is SQL?', 'mcq', 10, 'A', 'B', 'C', 'D', 'A';




------------------------------------------------------------------
alter proc [dbo].[add_student] (
      @St_name nvarchar(30)
	  ,@email nvarchar(30)
      ,@city varchar(20)
      ,@st_gender nvarchar(10)
      ,@St_age int
	  ,@grad_year int
      ,@Track_id int   
	  ,@St_phone nvarchar(11)
	  ,@branch_id int
	  ,@intake_id int
	  ,@t_manager_id int
	  ,@t_manager_password varchar(20)
	  )
as 
begin
    if exists (select 1 from Log_Account a 
			   where a.id = @t_manager_id and a.password =@t_manager_password and a.type = 't'
	)
	begin
	insert into Students
	values (@St_name, @email, @city, @st_gender, @St_age, @grad_year, @Track_id,@St_phone, @branch_id,@intake_id)
	end
	else
	begin
		print 'you do not have permission'
	end
end


--test
exec [add_student] 'Ahmed Ahmed', 'ahmedahmed@gmail.com', 'Damietta', 'Male', 23, 2023, 1, '01004084555', 1, 5, '111'



---------------------------------------------------------------------------------

--------------------------------------------- edited
alter procedure [dbo].[create_exam] (
    @ins_id int,
    @password varchar(50),
    @c_id int,
    @exam_type varchar(30),
    @star_time datetime,
    @end_time datetime,
    @duration int,
    @total_degree int
)
as
begin
    if exists (select 1 from log_account where id = @ins_id and [password] = @password and type = 'i' )
        and exists (select 1 from Ins_course where ins_id = @ins_id and c_id = @c_id )
    begin  
        begin try
            insert into exam
            values ( @exam_type,@star_time,@end_time, @duration, @total_degree, @c_id );
        end try
        begin catch
            select error_message() as [error message]
                ,error_line() as errorline
                ,error_number() as [error number]
                ,error_state() as [error state];
        end catch
    end
    else
    begin
        select 'you cannot create this exam because you have not taught this course' as error;
    end
end

exec [create_exam] 4 , 111 , 15 , 'normal' ,'2024-03-5 10:00:00.000' , '2024-03-20 12:00:00.000' , 2 , 100
select * from Exam
--run
--not tested
select * from Exam_Question q , question_choices qc
where q.q_id = qc.Qus_No and Exam_id = 18 and qc.Is_Correct = 1

EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'normal', @star_time = '2024-03-15 10:00:00', @end_time = '2024-03-30 11:00:00', @duration = 1, @total_degree = 100 ,@C_ID = 17;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'corrective', @star_time = '2024-03-15 12:00:00', @end_time = '2024-03-15 14:00:00', @duration = 2, @total_degree = 100;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'normal', @star_time = '2024-04-01 09:00:00', @end_time = '2024-04-01 12:00:00', @duration = 2, @total_degree = 120;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'normal', @star_time = '2024-04-05 13:00:00', @end_time = '2024-04-05 15:00:00', @duration = 2, @total_degree = 100;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'normal', @star_time = '2024-04-10 15:00:00', @end_time = '2024-04-10 16:00:00', @duration = 1, @total_degree = 100;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'normal', @star_time = '2024-03-20 11:00:00', @end_time = '2024-03-20 12:00:00', @duration = 1, @total_degree = 100;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'normal', @star_time = '2024-03-25 14:00:00', @end_time = '2024-03-25 16:00:00', @duration = 2, @total_degree = 80;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'corrective', @star_time = '2024-04-15 08:00:00', @end_time = '2024-04-15 10:00:00', @duration = 2, @total_degree = 100;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'normal', @star_time = '2024-04-20 16:00:00', @end_time = '2024-04-20 17:30:00', @duration = 1, @total_degree = 100;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'normal', @star_time = '2024-03-30 10:30:00', @end_time = '2024-03-30 11:30:00', @duration = 1, @total_degree = 100;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'corrective', @star_time = '2024-04-02 12:00:00', @end_time = '2024-04-02 13:00:00', @duration = 1, @total_degree = 100;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'normal', @star_time = '2024-04-25 08:00:00', @end_time = '2024-04-25 11:00:00', @duration = 2, @total_degree = 100;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'normal', @star_time = '2024-04-07 13:00:00', @end_time = '2024-04-07 13:45:00', @duration = 1, @total_degree = 100;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'corrective', @star_time = '2024-03-22 11:15:00', @end_time = '2024-03-22 12:00:00', @duration = 1, @total_degree = 100;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'normal', @star_time = '2024-04-12 14:00:00', @end_time = '2024-04-12 15:30:00', @duration = 2, @total_degree = 100;
EXEC [dbo].[create_exam] @ins_id = 3, @password = '111', @exam_type = 'corrective', @star_time = '2024-04-08 09:30:00', @end_time = '2024-04-08 10:30:00', @duration = 2, @total_degree = 100;







-----------------------------------------------------------

--finish
alter proc [dbo].[delete_course] (
       @c_id int
	  ,@Tran_id int
	  ,@password varchar(20)
	  )
as 
begin
    BEGIN TRY
    if @password = (select password from log_account where id = @Tran_id and type = 't') 
	begin
		delete from courses
		where course_id = @c_id
	end
	else
	begin
		print 'you do not have permission'
	end
	END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine;
    END CATCH;
end


--test
exec [delete_course] 15, 5, '111'


---------------------------------------------------------------------

--finish
alter proc [dbo].[delete_department] (
      @dept_id int
	  ,@Tran_id int
	  ,@password varchar(20)
	  )
as 
begin
    if @password = (select password from log_account where id = @Tran_id and type = 't') 
	begin
		delete from [dbo].[Department]
		where dept_id = @dept_id
	end
	else
	begin
		print 'you do not have permission'
	end
end


--test
exec [delete_department] 7, 5, '111'


-------------------------------------------------------------------------------
--finish
alter procedure [dbo].[delete_exam] (@e_id int)
as
begin
    delete from [dbo].[Exam]
    where exam_id = @e_id;
    delete from [dbo].[Exam_Question]
    where Exam_id = @e_id;
end;


--run
--not tested

exec [delete_exam] 



-------------------------------------------------------
--finish
alter proc [dbo].[delete_ins_course] (
	   @Ins_id int
	  ,@C_id int
	  ,@Tran_id int
	  ,@password Varchar(20))
as
begin
    if @password = (select password from log_account where id = @Tran_id and type = 't') 

	begin

			delete from [dbo].[Ins_course]
			where Ins_id = @Ins_id and C_id = @C_id;
	end
	else
	begin
		print 'you dont have permission'
	end
end


--test
exec [delete_ins_course] 67,2, 5, '111'

-----------------------------------------------------------------------
--finish
create proc [dbo].[delete_instructor] (
	   @Ins_id int)
as
begin
	delete from [dbo].[instructors]
	where Ins_id = @Ins_id;
end


--test
exec [delete_instructor] 67

-----------------------------------------------------------------------

--finish
alter proc [dbo].[delete_intake](@intake_num varchar(20))
as 
begin
	delete from [dbo].[Intake]
	where [Intake_num] = @intake_num
end


--test
exec [delete_intake] 'Intake32_Round3' 
-----------------------------------------------------------------------

--finish
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



--test
exec [delete_question] 3, '111', 301


-----------------------------------------------------------------------


select * from St_course



--finish

create proc [dbo].[delete_st_Course] (@st_id int , @c_id int)
as
begin
delete from St_course
where st_id = @st_id and C_id = @c_id
end


--test
exec [delete_st_Course] 118,1

-----------------------------------------------------------------------

--finish
alter proc [dbo].[delete_student] (
      @St_id int
	  ,@t_manager_id int
	  ,@t_manager_password varchar(20)
	  )
as 
begin
    if exists (select 1 from Log_Account a 
			   where a.id = @t_manager_id and a.password =@t_manager_password and a.type = 't'
	)
	begin
		delete from Students
		where St_id = @St_id
	end
	else
	begin
		print 'you do not have permission'
	end
end


--test
exec [delete_student] 221, 5, '111'

-----------------------------------------------------------------------


--finish
CREATE PROCEDURE [dbo].[Deletetrack](
	@Track_id int
)
AS
BEGIN
    DELETE FROM [dbo].[Track]
    WHERE [Track_id] = @Track_id;
END;

--test
exec [Deletetrack] 12

-----------------------------------------------------------------------

--finish
CREATE PROCEDURE [dbo].[Deletetrackcourse](
	@Track_id int
)
AS
BEGIN
    DELETE FROM [dbo].[Track_Course]
    WHERE [Track_id] = @Track_id;
END;


-----------------------------------------------------------------------

--finish
CREATE PROCEDURE [dbo].[Deletetrainingmanager](
	@manager_id int
)
AS
BEGIN
    DELETE FROM [dbo].[Training_manager]
    WHERE [manager_id] = @manager_id;
END;
-----------------------------------------------------------------------


--finich
alter proc [dbo].[update_branch] (@old_city_name nvarchar(max), @new_city_name nvarchar(max), @t_manager_id int, @t_manager_password varchar(20))
as
begin
    if exists (select 1 from Log_Account a 
	           join [Training_manager] tm 
			   on a.id = tm.[manager_id]
			   where a.id = @t_manager_id and a.password =@t_manager_password and a.type = 'T'
	)
	begin
	update [dbo].[Branch]
	set [Branch] = @new_city_name
	where [Branch] = @old_city_name
	end
	else
	begin
		print 'you dont have permission'
	end
end

--test
exec [update_branch] 'Sohag', 'Damietta' , 5, '111'

-----------------------------------------------------------------------

--finish
alter proc [dbo].[edit_Branch_Dept] (@Bran_ID int, @old_Dept_ID int, @new_Dept_ID int ,@t_manager_id int, @t_manager_password varchar(20))
as
begin
    if exists (select 1 from Log_Account a 
	           join [Training_manager] tm 
			   on a.id = tm.[manager_id]
			   where a.id = @t_manager_id and a.password =@t_manager_password and a.type = 'T'
	)
	begin
		update [dbo].[Branch_Dept]
		set Dept_ID = @new_Dept_ID
		where Bran_ID = @Bran_ID and Dept_ID = @old_Dept_ID
	end
	else
	begin
		print 'you do not have permission'
	end
end


--test
exec [edit_Branch_Dept] 1, 4, 1, 5, '111'

-----------------------------------------------------------------------




--finich
alter proc [dbo].[edit_Branch_intake] (@Bran_ID int, @old_Intake_ID int, @new_Intake_ID int, @t_manager_id int, @t_manager_password varchar(20))
as
begin
    if exists (select 1 from Log_Account a 
			   where a.id = @t_manager_id and a.password =@t_manager_password and a.type = 't'
	)
	begin
		update [dbo].[Branch_Intake]
		set Intake_ID = @new_Intake_ID
		where Bran_ID = @Bran_ID and Intake_ID = @old_Intake_ID
	end
	else
	begin
		print 'you do not have permission'
	end
end


--test
exec [edit_Branch_intake] 1, 14, 15, 5, '111'
-----------------------------------------------------------------------

create procedure [dbo].[exam_template] (@course_ID int,@numderOfQuestion int, @type varchar(20))
as
begin
	select * from exam_info(@course_ID)
	where Exam_type = @type
	exec random_question @course_ID, @numderOfQuestion 

end


--run
--not tested
exec [exam_template] 1, 5, 'normal'



-----------------------------------------------------------------------

--finish
alter procedure [dbo].[get_student_grades] ( @student_id int , @password varchar(50))
as
begin
	if @password = (select password from log_account where id = @student_id and type = 's')
	begin
		select S.St_name , C.course_name , sc.grade , case 
													when Sc.grade >= C.min_degree then 'successed'
													else 'Faild'
													end as [status]
		from students S , courses C , st_course SC
		where S.St_id = SC.st_id and SC.C_id = C.course_id
		and S.st_id = @student_id
	end
	else 
	begin
		select 'You can view your grades only ' as error
	end
end

--run
--not tested


-----------------------------------------------------------------------


--finish
alter procedure [dbo].[get_students_corrective_in_course] (@ins_id int ,@password varchar(50),  @course_id int)
as
begin
	if @password = (select password from log_account where id = @ins_id and type = 'i') and 
				@course_id in (select c_id from Ins_course where Ins_id = @ins_id)
		begin
				select S.St_id , s.St_name ,c.course_name , t.Track_name 
				from St_course St , Courses c , Students S , track T
				where s.St_id = st.st_id and st.C_id = c.course_id  and s.Track_id = t.Track_id and st.C_id = @course_id
				and st.grade < c.min_degree
		end
	else 
		begin
			select 'you do not have permission to show that' as error
		end
end

--run
--not tested


-----------------------------------------------------------------------

--finish
alter procedure [dbo].[get_students_corrective_in_Exam] (@ins_id int ,@password varchar(50), @Exam_id int)
as
begin
	
	declare @c_id int 
	select @c_id = (select C_id from pick_exam PE where PE.Exam_id = @Exam_id)
	if @password = (select password from log_account where id = @ins_id and type = 'i') and 
				@c_id in (select c_id from Ins_course where Ins_id = @ins_id)
		begin
			select  distinct S.St_id , s.St_name ,c.course_name , t.Track_name 
			from St_course St , Courses c , Students S , track T ,exam x
			where s.St_id = st.st_id and st.C_id = c.course_id  and s.Track_id = t.Track_id and  
			st.C_id = @c_id and st.grade < c.min_degree
		end
	else
		begin
			select 'you do not have a permission to show this data'
		end
	
end

--run
--not tested

-----------------------------------------------------------------------

--finish
alter procedure [dbo].[insert_answers]
   ( @exam_id int, 
    @st_id int, 
    @q_id int, 
    @answer varchar(50)
)as 
begin
	
    declare @current_date datetime = getdate();

    declare @start_time datetime;
    declare @end_time datetime;

    select @start_time = start_time, @end_time = end_time 
    from exam 
    where exam_id = @exam_id;

	if @st_id in (select St_ID from Pick_Exam where EXam_ID = @exam_id) and
	@current_date between @start_time and @end_time
    begin
        insert into student_answers (e_id, st_id, q_id, answer)
        values (@exam_id, @st_id, @q_id, @answer);
    end
    else 
    begin
        select ('you do not have premssion do take this exam or The time for this exam has ended') as error;
    end
end
select * from Exam_Question q, question_choices qc where q.Q_ID=qc.Qus_No and qc.Is_Correct = 1
select * from Pick_Exam --st 1 2 3 4 5  ex 16 
--run
--not tested


exec [insert_answers] 16 , 1 , 102 , 'true'
exec [insert_answers] 16 , 1 , 104 , 'false'
exec [insert_answers] 16 , 1 , 107 , 'TRUE'
exec [insert_answers] 16 , 1 , 109 , 'false'
exec [insert_answers] 16 , 1 , 111 , ' Web Services'
exec [insert_answers] 16 , 1 , 112 , ' All of the mentioned'
exec [insert_answers] 16 , 1 , 113 , ' XML + HTTP'
exec [insert_answers] 16 , 1 , 118 , ' Big Web Services'
exec [insert_answers] 16 , 1 , 119 , ' JAX-RPC'
exec [insert_answers] 16 , 1 , 120 , ' jaxws:endpoint'

select * from St_course
where st_id = 1 and C_id =6
select * from Exam

-----------------------------------------------------------------------

alter procedure [dbo].[insert_into_st_course] (@Course_id int, @Track_id int)
as
begin
    declare @st_id int, @c_id int

    declare get_students cursor
    for select st_id, @Course_id from students where Track_id = @Track_id

    open get_students;

    fetch next from get_students into @st_id, @c_id
    while @@fetch_status = 0
    begin
        insert into St_course (st_id, C_id)
        values (@st_id, @c_id);
        fetch next from get_students into @st_id, @c_id
    end;

    close get_students
    deallocate get_students
end
GO


alter procedure update_question (
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
                update question_pool 
                set corr_ans = @correction
                where q_id = @q_id
            end
            else if @indicator = 3
            begin 
                update question_pool 
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


exec update_question 
--test + fill data
exec [insert_into_st_course] 10,1

---------------------------- users
exec [dbo].[show_student_exams] 11 , 12345 


exec [get_students_corrective_in_course] 4 , 111 , 5

select * from Ins_course
where Ins_id = 3
--Student
GRANT EXEC ON [dbo].[get_student_grades] TO [ST_Bassem_Hassan];
GRANT EXEC ON [dbo].[show_student_exams] TO [ST_Bassem_Hassan];

-----
GRANT EXEC ON [dbo].[get_student_grades] TO [ST_Dalia_Mansour];
GRANT EXEC ON [dbo].[show_student_exams] TO [ST_Dalia_Mansour];
`
--instructor
GRANT EXEC ON [dbo].[create_exam] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].add_new_question TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[get_students_corrective_in_course] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[get_students_corrective_in_Exam] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[delete_exam] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[delete_question] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[exam_template] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[insert_question] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[random_question] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[update_exam] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[update_exam_question] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[update_question] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[delete_question] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[get_questions] TO [INS_Amira_Kamal];

-----------[dbo].[add_new_question]
GRANT EXEC ON [dbo].[create_exam] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].add_new_question TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[get_students_corrective_in_course] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[get_students_corrective_in_Exam] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[delete_exam] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[delete_question] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[exam_template] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[insert_question] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[random_question] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[update_exam] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[update_question] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[update_exam_question] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[delete_question] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[get_questions] TO [INS_Malek_Hassan];



--training manager
GRANT EXEC ON [dbo].[add_branch] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[add_Branch_Dept] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[add_Branch_intake] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[add_Branch_track] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[add_course] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[add_department] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[add_intake] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[add_student] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[delete_course] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[delete_intake] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[delete_student] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[Deletetrack] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[Deletetrackcourse] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[update_branch] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[edit_Branch_intake] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[update_Branch_track] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[update_courses] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[update_department] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[update_student] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[Inserttrack] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[update_intake] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[updatetrack] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[updatetrackcourse] TO [TRA_Mohamed_Ibrahem];

---------
GRANT EXEC ON [dbo].[add_branch] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[add_Branch_Dept] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[add_Branch_intake] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[add_Branch_track] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[add_course] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[add_department] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[add_intake] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[add_student] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[delete_course] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[delete_intake] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[delete_student] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[Deletetrack] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[Deletetrackcourse] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[update_branch] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[edit_Branch_intake] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[update_Branch_track] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[update_courses] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[update_department] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[update_student] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[Inserttrack] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[update_intake] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[updatetrack] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[updatetrackcourse] TO [TRA_Hazem_Rashed];
