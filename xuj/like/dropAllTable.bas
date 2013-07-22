Sub createPostgreSQLSeq()

		Dim sheetCount As Integer
		Dim x As Integer
		Dim y As Integer
		Dim loopSafe As Integer
		'シーケンスを利用する?
		Dim useSequence As Boolean
		'シーケンスの対象フィールド
		Dim sequenceField As String
		Dim sequenceName As String
		Dim fileName As String
		Dim targetSheet As Worksheet

		Debug.Print "Postgres用DBテンプレート作成マクロ"

		'目標フィールドが見つからないとき、あきらめる行数。
		loopSafe = 300


		Dim fs
		Set fs = CreateObject("Scripting.FileSystemObject")

		'同じファイル名のテキストファイル作?
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


		If targetSheet.Name <> "表紙" And targetSheet.Name <> "更新履歴" And targetSheet.Name <> "title" Then


				targetSheet.Activate
				With targetSheet
						' Debug.Print .Cells(3, 3)
						useSequence = False
						sequenceName = ""
						sequenceField = ""

						'シーケンスの場所を捜?
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
						' TODO 定義されているフィールドを記録
						End If

				End With

		End If

		sheetCount = sheetCount + 1

		Loop

		'終?
		fp.Close


End Sub
