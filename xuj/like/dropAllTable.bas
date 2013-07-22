Sub createPostgreSQLSeq()

		Dim sheetCount As Integer
		Dim x As Integer
		Dim y As Integer
		Dim loopSafe As Integer
		'�V�[�P���X�𗘗p����?
		Dim useSequence As Boolean
		'�V�[�P���X�̑Ώۃt�B�[���h
		Dim sequenceField As String
		Dim sequenceName As String
		Dim fileName As String
		Dim targetSheet As Worksheet

		Debug.Print "Postgres�pDB�e���v���[�g�쐬�}�N��"

		'�ڕW�t�B�[���h��������Ȃ��Ƃ��A������߂�s���B
		loopSafe = 300


		Dim fs
		Set fs = CreateObject("Scripting.FileSystemObject")

		'�����t�@�C�����̃e�L�X�g�t�@�C����?
		fileName = fs.GetParentFolderName(ActiveWorkbook.FullName) & "\" & fs.GetBaseName(ActiveWorkbook.FullName) & ".txt"
		Debug.Print fileName

		If fs.FileExists(fileName) Then
				x = 1
				Do While fs.FileExists(fs.GetParentFolderName(ActiveWorkbook.FullName) & "\" & fs.GetBaseName(ActiveWorkbook.FullName) & x & ".txt")

						x = x + 1
				Loop
				fileName = fs.GetParentFolderName(ActiveWorkbook.FullName) & "\" & fs.GetBaseName(ActiveWorkbook.FullName) & x & ".txt"
		End If

		Set fp = fs.CreateTextFile(fileName, True)

		sheetCount = 1
		Do While sheetCount <= ActiveWorkbook.Worksheets.count


		Set targetSheet = ActiveWorkbook.Worksheets(sheetCount)


		If targetSheet.Name <> "�\��" And targetSheet.Name <> "�X�V����" And targetSheet.Name <> "title" Then


				targetSheet.Activate
				With targetSheet
						' Debug.Print .Cells(3, 3)
						useSequence = False
						sequenceName = ""
						sequenceField = ""

						'�V�[�P���X�̏ꏊ��{?
						y = 9
						Do While .Cells(y, 2) <> "SEQUENCE"
							y = y + 1
							If y > loopSafe Then
									Exit Do
							End If
						Loop

						fp.writeline ("drop table " & .Cells(3, 3) & ";")
						y = 9
						z = y + 5
						
						If .Cells(z, 2) = "INDEX" And .Cells(z + 2, 2) <> "" Then
						Debug.Print y & " " & .Cells(z + 2, 2)
						Do While .Cells(z + 2, 2) <> ""
								fp.writeline ("drop sequence " & .Cells(z + 2, 2))
								z = z + 1
						Loop    
								fp.writeline ("")
						' TODO ��`����Ă���t�B�[���h���L�^
						End If

				End With

		End If

		sheetCount = sheetCount + 1

		Loop

		'�I?
		fp.Close


End Sub
