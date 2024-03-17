

create procedure [dbo].[insert_answers]
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


----------------------------

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


------------------------------------------------------------

alter trigger insert_student_grade_after_check
on student_answers
after insert
as
begin
    declare @st_id int, @c_id int;
    declare @grade int;

    declare update_cursor cursor for
        select ins.st_id, e.c_id
        from inserted ins , exam e 
		where e.exam_id = ins.e_id;

    open update_cursor;

    fetch next from update_cursor into @st_id, @c_id;

    while @@fetch_status = 0
    begin
        update st_course
        set grade = cd.total_degree
        from st_course st , calaculate_degrees() cd 
		where st.st_id = cd.st_id and st.c_id = cd.c_id
        and st.st_id = @st_id and st.c_id = @c_id;

        fetch next from update_cursor into @st_id, @c_id;
    end

    close update_cursor;
    deallocate update_cursor;

end


---------------------------------------------------
select * from Exam_Question q, question_choices qc where q.Q_ID=qc.Qus_No and qc.Is_Correct = 1
select * from Pick_Exam 


exec [insert_answers] 16 , 2 , 102 , 'true'
exec [insert_answers] 16 , 2 , 104 , 'false'
exec [insert_answers] 16 , 2 , 107 , ''
exec [insert_answers] 16 , 2 , 109 , ''
exec [insert_answers] 16 , 2 , 111 , ' Web Services'
exec [insert_answers] 16 , 2 , 112 , ' All of the mentioned'
exec [insert_answers] 16 , 2 , 113 , ' XML + HTTP'
exec [insert_answers] 16 , 2 , 118 , ' Big Web Services'
exec [insert_answers] 16 , 2 , 119 , ' JAX-RPC'
exec [insert_answers] 16 , 2 , 120 , ' jaxws:endpoint'


