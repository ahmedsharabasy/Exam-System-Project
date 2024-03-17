

select * from [dbo].[Log_Account]




--Student
GRANT EXEC ON [dbo].[get_student_grades] TO [ST_Bassem_Hassan];
GRANT EXEC ON [dbo].[show_student_exams] TO [ST_Bassem_Hassan];
GRANT EXEC ON [dbo].[insert_answers] TO [ST_Bassem_Hassan];


-----
GRANT EXEC ON [dbo].[get_student_grades] TO [ST_Dalia_Mansour];
GRANT EXEC ON [dbo].[show_student_exams] TO [ST_Dalia_Mansour];
GRANT EXEC ON [dbo].[insert_answers] TO [ST_Dalia_Mansour];

-----
GRANT EXEC ON [dbo].[get_student_grades] TO ST_samy_Mostafa;
GRANT EXEC ON [dbo].[show_student_exams] TO ST_samy_Mostafa;
GRANT EXEC ON [dbo].[insert_answers] TO ST_samy_Mostafa;


--instructor
GRANT EXEC ON [dbo].[create_exam] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].add_new_question TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[get_students_corrective_in_course] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[get_students_corrective_in_Exam] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[delete_exam] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[delete_question] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[exam_template] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].add_new_question TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[random_question] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[update_exam] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[update_exam_question] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[update_question] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[delete_question] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].[get_questions] TO [INS_Amira_Kamal];
GRANT EXEC ON [dbo].GetLastInsertedExamID TO [INS_Amira_Kamal];


-----------[dbo].[add_new_question]
GRANT EXEC ON [dbo].[create_exam] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].add_new_question TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[get_students_corrective_in_course] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[get_students_corrective_in_Exam] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[delete_exam] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[delete_question] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[exam_template] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].add_new_question TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[random_question] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[update_exam] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[update_question] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[update_exam_question] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[delete_question] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].[get_questions] TO [INS_Malek_Hassan];
GRANT EXEC ON [dbo].GetLastInsertedExamID TO [INS_Malek_Hassan];




--training manager
GRANT EXEC ON [dbo].[add_branch] TO [TRA_Mohamed_Ibrahem];
GRANT EXEC ON [dbo].[add_Branch_Dept] TO [TRA_Mohamed_Ibrahem];
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
GRANT EXEC ON [dbo].[update_courses] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[update_department] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[update_student] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[Inserttrack] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[update_intake] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[updatetrack] TO [TRA_Hazem_Rashed];
GRANT EXEC ON [dbo].[updatetrackcourse] TO [TRA_Hazem_Rashed];