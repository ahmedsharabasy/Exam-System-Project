
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

exec [get_students_corrective_in_course] 3,111,3

-----------------------------------------------------------------------

--finish
alter procedure [dbo].[get_students_corrective_in_Exam] (@ins_id int ,@password varchar(50), @Exam_id int)
as
begin
	
	declare @c_id int 
	select @c_id = (select top 1 C_id from pick_exam PE where PE.Exam_id = @Exam_id)
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
select * from Exam
exec [get_students_corrective_in_Exam] 3, 111 , 24

-------------------------------------------


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

---------------------------------------------

alter procedure get_exam_question (@exam_id int)
as
begin
	select Q.question , q.type , q.q_degree ,qc.Choice_Text as correct_answer
	from Exam_Question EQ , questions Q ,question_choices QC
	where EQ.Q_ID = Q.q_id  and EQ.Q_ID = QC.Qus_No and qc.Is_Correct=1 and EQ.Exam_id = @exam_id
end
exec get_exam_question 29

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

exec [show_student_exams] 3, 111


----------------------------------------------

alter procedure get_students_info_in_branch (@branch_id int)
as
begin
	select s.st_id,s.st_name,s.email,s.city , s.st_gender ,s.st_age ,s.phone , t.Track_name,i.Intake_num
	from students s , Track T , Intake I 
	where s.track_id = t.Track_id and s.intake_ID = i.Intake_id and s.Bran_ID = @branch_id
end

exec get_students_info_in_branch 1
