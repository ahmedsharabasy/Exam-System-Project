
exec [add_student] 'Ahmed shaban', 'ahmed@gmail.com', 'cairo', 'Male', 23, 2023, 1, '01144051946', 1,10, 5, '111'


exec [add_intake] 'Intake355_Round3', 5, '111'

exec [update_intake] 'Intake32_Round3', 'Intake32_Round90' , 5, '111'

exec [delete_intake] 'Intake355_Round3' 

exec [dbo].[Inserttrack] 'embeded'

exec [updatetrack] 1, 'project management'

exec [Deletetrack] 12

exec [updatetrackcourse]  1, 1, 2

exec [add_branch] Damietta , 5, '111'

exec [update_branch] 'Sohag', 'Damietta' , 5, '111'

exec [add_department] 'data', 5, '111' 

exec [delete_department] 7, 5, '111'

exec [add_Branch_Dept] 7,3 , 5, '111'

exec [edit_Branch_Dept] 1, 4, 1, 5, '111'




select * from Log_Account
