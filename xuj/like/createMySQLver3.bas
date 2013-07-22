Attribute VB_Name = "createMySQLver3"

Sub createMySQLTemplate55()

		Dim sheetCount As Integer
		Dim x As Integer
		Dim y As Integer
		Dim z As Integer
		Dim m As Integer
		Dim n As Integer
		Dim indexCount As Integer
		Dim bigName As String
		Dim loopSafe As Integer
		Dim fileName As String
		Dim targetSheet As Worksheet

		Dim StrIndex As String

		Debug.Print "DBテンプレート作成マクロ"

		loopSafe = 150

		Dim fs
		Set fs = CreateObject("Scripting.FileSystemObject")

		'同じファイル名のテキストファイル作成
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


		If targetSheet.Name <> "表紙" And targetSheet.Name <> "更新履歴" Then


				targetSheet.Activate
				With targetSheet
						' Debug.Print .Cells(3, 3)
						fp.WriteLine ("---- create table " & .Cells(3, 3) & "--")
						fp.WriteLine ("")


						'テーブル作成
						fp.WriteLine ("CREATE TABLE " & .Cells(3, 3) & "(")
						'本体部分を捜す
						y = 8
						Do While .Cells(y, 2) <> "TABLE"
								y = y + 1
								If y > loopSafe Then
										Exit Do
								End If
						Loop

						z = 10
						'bigintの取得
						Do While .Cells(z, 2) <> "SEQUENCE"
								z = z + 1
								If z > loopSafe Then
										Exit Do
								End If
						Loop

						z = z + 2
						Do Until .Cells(z, 2) = ""
								If .Cells(z, 8) = "9223372036854770000" Then
										bigName = .Cells(z, 3)
								Else
										bigName = ""
								End If

								z = z + 1
								If z > loopSafe Then
										Exit Do
								End If
						Loop
						'bigintの取得--------END

						'INDEXの作成
						n = 10
						Do While .Cells(n, 2) <> "INDEX"
								n = n + 1
								If n > loopSafe Then
										Exit Do
								End If
						Loop

						indexCount = 1
						If .Cells(n + 2, 2) = "" Then
								indexCount = 0
						End If

						'ここから本体の内容
						y = y + 2
						Do Until .Cells(y, 2) = ""
								Dim line As String
								'フィールド名 タイプ
								If UCase(.Cells(y, 2)) = "ID" Then
										If UCase(.Cells(y, 2)) = UCase(bigName) Then
												line = .Cells(y, 2) & " bigint" & " unsigned"
										Else
												line = .Cells(y, 2) & " " & .Cells(y, 3) & " unsigned"
										End If
								Else
										If UCase(.Cells(y, 2)) = UCase(bigName) Then
												line = .Cells(y, 2) & " bigint"
										Else
												If UCase(.Cells(y, 3)) = "BOOLEAN" Then
														line = .Cells(y, 2) & " tinyint(1)"
												Else
														line = .Cells(y, 2) & " " & .Cells(y, 3)
												End If
										End If
								End If

								'NULL制約
								If .Cells(y, 5) = "N" Then
										line = line & " NOT NULL"
								End If

								'デフォルト値、シーケンスの指定
								If .Cells(y, 6) <> "" And UCase(.Cells(y, 2)) <> "REGISTRATION_DATE" Then
										If UCase(.Cells(y, 6)) = "TRUE" Then
												line = line & " DEFAULT '1'"
										ElseIf UCase(.Cells(y, 6)) = "FALSE" Then
												line = line & " DEFAULT '0'"
										ElseIf .Cells(y, 6) = "now()" Then
												line = line & " DEFAULT now()"
										Else
												line = line & " DEFAULT '" & .Cells(y, 6) & "'"
										End If
								End If

								'PrimaryKeyのセット
								'TODO Pがついていたら、Primary keyではあるが、auto_incrementはシーケンスで指定されたフィールドにつける。
								'TODO 同様に、auto_incrementのフィールドは１つとは限らない。
								If .Cells(y, 4) = "P" Then
										line = line & " PRIMARY KEY auto_increment"
								End If

								'次の行があるならコンマで続ける
								line = line & ","
								If .Cells(y + 1, 2) = "" Then
										line = Left(line, Len(line) - 1)
								End If

								fp.WriteLine (vbTab & line)
								y = y + 1
								If y > loopSafe Then
										Exit Do
								End If
						Loop

						'INDEXの作成
						Do While .Cells(y, 2) <> "INDEX"
								y = y + 1
								If y > loopSafe Then
										Exit Do
								End If
						Loop

						y = y + 2
						Do While .Cells(y, 2) <> ""
								m = 10
								Do While .Cells(m, 2) <> ""
										If .Cells(m, 2) = .Cells(y, 3) Then
												'TEXT型には、自動で255のINDEXをつける
												If UCase(.Cells(m, 3)) = "TEXT" Then
														If .Cells(y, 6) = "Y" Then
																line = vbTab & "UNIQUE (" & .Cells(y, 3) & "(255))"
														Else
																StrIndex = StrIndex & "Create INDEX " & .Cells(y, 2) & " ON " & .Cells(3, 3) & "(" & .Cells(y, 3) & "(255));" & vbCrLf
														End If
												Else
														If .Cells(y, 6) = "Y" Then
																line = vbTab & "UNIQUE (" & .Cells(y, 3) & ")"
														Else
																StrIndex = StrIndex & "Create INDEX " & .Cells(y, 2) & " ON " & .Cells(3, 3) & "(" & .Cells(y, 3) & ");" & vbCrLf
														End If
												End If
												Exit Do
										End If

										m = m + 1
										If m > loopSafe Then
												Exit Do
										End If
								Loop

								'次の行があるならコンマで続ける
								If .Cells(y + 1, 2) <> "" Then
										'line = line & ","
								End If
								'fp.WriteLine (line)

								y = y + 1
								If y > loopSafe Then
										Exit Do
								End If
						Loop
						fp.WriteLine (") ENGINE = INNODB;")
						fp.WriteLine ("")
						fp.WriteLine (StrIndex)
						fp.WriteLine ("")

				End With

		End If

		sheetCount = sheetCount + 1

		StrIndex = ""

		Loop

		'終了
		fp.Close

End Sub
