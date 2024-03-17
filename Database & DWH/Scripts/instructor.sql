
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


exec [create_exam] 4 , 111 , 18 , 'corrective' ,'2024-03-15 10:00:00.000' , '2024-03-15 12:00:00.000' , 2 , 100

---------------------------------------------------------------------------------------------------

alter trigger Select_exam_student
on exam
after insert
as
begin
    declare @exam_id int
    select @exam_id = exam_id from inserted

    declare @cours_id int
    select @cours_id = C_ID from inserted

    declare @ins_id int
    select @ins_id = (select top 1 ic.ins_id from ins_course ic , inserted ins where ic.c_id = ins.c_id)

    declare @st_id_normal table (st_id int)
    insert into @st_id_normal (st_id)
    select sc.st_id
    from st_course sc , inserted ins
    where grade is null and sc.c_id = ins.c_id

    declare @st_id_corrective table (st_id int)
    insert into @st_id_corrective (st_id)
    select sc.st_id
    from st_course sc , inserted ins , courses c
    where sc.grade > c.min_degree and c.course_id =sc.c_id and  sc.c_id = ins.c_id



    declare @st_id_cursor cursor
    if (select type from inserted) = 'normal'
        set @st_id_cursor = cursor for select st_id from @st_id_normal
    else
        set @st_id_cursor = cursor for select st_id from @st_id_corrective

    open @st_id_cursor
    declare @st_id_value int
    fetch next from @st_id_cursor into @st_id_value
    while @@fetch_status = 0
    begin
        insert into pick_exam (exam_id, c_id, st_id, ins_id)
        values (@exam_id, @cours_id, @st_id_value, @ins_id)
        fetch next from @st_id_cursor into @st_id_value
    end
    close @st_id_cursor
    deallocate @st_id_cursor

end


------------------------------------------------------

alter procedure [dbo].[get_questions] (@Course_id int)
as 
begin
	select Q.Q_id ,Q.question , Q.type , Q.Q_degree 
	from [dbo].[questions] Q , [dbo].[courses] C
	where Q.C_id = C.[course_id] and C.course_id = @Course_id
end


exec [get_questions] 18

------------------------------------------------------------

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

exec [dbo].[GetLastInsertedExamID]

exec [random_question] 1022 , 10