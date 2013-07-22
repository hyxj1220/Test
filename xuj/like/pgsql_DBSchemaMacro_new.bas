Sub create_DB()

    Dim sheetCount As Integer
    Dim x As Integer
    Dim y As Integer
    Dim loopSafe As Integer
    Dim useSequence As Boolean
    Dim fileName As String
    Dim targetSheet As Worksheet
    Dim SequenceName As String
    
    Debug.Print "DBテンプレート作成マクロ"
    
    Dim fs
    Set fs = CreateObject("Scripting.FileSystemObject")
    
    '同じファイル名のテキストファイル作成
    fileName = fs.GetParentFolderName(ActiveWorkbook.FullName) & "\" & fs.GetBaseName(ActiveWorkbook.FullName) & ".txt"
    Debug.Print fileName
    
    Set fp = fs.CreateTextFile(fileName, True)
  
    sheetCount = 1
    Do While sheetCount <= ActiveWorkbook.Worksheets.count
    
    Set targetSheet = ActiveWorkbook.Worksheets(sheetCount)
    
    If targetSheet.Name <> "表紙" And targetSheet.Name <> "更新履歴" Then
    
    
        targetSheet.Activate
        With targetSheet
            ' Debug.Print .Cells(3, 3)
            useSequence = False
            fp.writeline ("----" & .Cells(3, 3) & "作成")
            fp.writeline ("")
            
            'シーケンスの場所を捜す
            y = 9
            Do While .Cells(y, 2) <> "SEQUENCE"
               y = y + 1
               'If y > loopSafe Then
               '    Exit Do
               'End If
            Loop
            '注意！自動ではint4型のシーケンスを作成するので、int8の時は手動で調整すること！
            If .Cells(y, 2) = "SEQUENCE" And .Cells(y + 2, 2) <> "" Then
            Debug.Print y & " " & .Cells(y + 2, 2)
                fp.writeline ("CREATE SEQUENCE " & .Cells(y + 2, 2) & " start 1 increment 1 maxvalue 2147483647 minvalue 1  cache 1 ;")
                fp.writeline ("REVOKE ALL ON " & .Cells(y + 2, 2) & " FROM PUBLIC;")
                fp.writeline ("GRANT ALL ON " & .Cells(y + 2, 2) & " TO PUBLIC;")
                fp.writeline ("")
                SequenceName = .Cells(y + 2, 2)
                useSequence = True
            ' TODO 定義されているフィールドを記録
            End If
            
            'テーブル作成
            fp.writeline ("CREATE TABLE " & .Cells(3, 3) & "(")
            '本体部分を捜す
            y = 8
            Do While .Cells(y, 2) <> "TABLE"
                y = y + 1
            Loop
            y = y + 2
            Do Until .Cells(y, 2) = ""
                Dim line As String
                line = .Cells(y, 2) & " " & .Cells(y, 3)
                
                If .Cells(y, 5) = "N" Then
                    line = line & " NOT NULL"
                End If
                If .Cells(y, 4) = "P" Then
                    line = line & " DEFAULT nextval('"
                 line = line & """"
                 line = line & SequenceName
                 line = line & """"
                 line = line & "'::text) PRIMARY KEY"
		End If
                If .Cells(y, 6) <> "" Then
                    If UCase(.Cells(y, 6)) = "TRUE" Then
                        line = line & " DEFAULT 'true'"
                    ElseIf UCase(.Cells(y, 6)) = "FALSE" Then
                        line = line & " DEFAULT 'false'"
                    ElseIf .Cells(y, 6) = "now()" Then
                        line = line & " DEFAULT now()"
                    Else
                        line = line & " DEFAULT '" & .Cells(y, 6) & "'"
                    End If
                End If
                
                'TODO sequenceに定義されているフィールドだったら、シーケンス追加
                Debug.Print line
                If .Cells(y + 1, 2) <> "" Then
                fp.writeline (vbTab & line & ",")
                Else
                fp.writeline (vbTab & line)
                End If
                y = y + 1
                
            Loop
                        
            fp.writeline (");")
            fp.writeline ("REVOKE ALL ON " & .Cells(3, 3) & " FROM PUBLIC;")
            fp.writeline ("GRANT ALL ON " & .Cells(3, 3) & " TO PUBLIC;")
            fp.writeline ("")

            z = y + 5
            
            If .Cells(z, 2) = "INDEX" And .Cells(z + 2, 2) <> "" Then
            Debug.Print y & " " & .Cells(z + 2, 2)
            Do While .Cells(z + 2, 2) <> ""
                fp.writeline ("CREATE INDEX " & .Cells(z + 2, 2) & " ON " & .Cells(3, 3) & "(" & .Cells(z + 2, 3) & ");")
                z = z + 1
            Loop    
                fp.writeline ("")
            ' TODO 定義されているフィールドを記録
            End If
    
        End With
    
    End If
    
    sheetCount = sheetCount + 1
    
    Loop
        
    '終了
    fp.Close
    
    MsgBox "DBテンプレート作成しました"

End Sub
