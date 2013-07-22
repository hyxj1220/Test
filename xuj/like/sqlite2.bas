
Sub createPostgreSQLTemplate()

    Dim sheetCount As Integer
    Dim x As Integer
    Dim y As Integer
    Dim loopSafe As Integer
    'シーケンスを利用する・
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
    
    '同じファイル名のテキストファイル作・
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
            fp.WriteLine ("----" & .Cells(3, 3) & "作成")
            fp.WriteLine ("")
            
            
            
            'テーブル作・
            fp.WriteLine ("CREATE TABLE " & .Cells(3, 3) & "(")
            '本体部分を捜・
            y = 8
            Do While .Cells(y, 2) <> "TABLE"
                y = y + 1
                If y > loopSafe Then
                    Exit Do
                End If
            Loop
            
            'ここから本体の内容
            y = y + 2
            Do Until .Cells(y, 2) = ""
                Dim line As String
                'フィールド名 タイプ
                line = .Cells(y, 2) & " " & .Cells(y, 3)
                
                'NULL制・
                If .Cells(y, 5) = "N" Then
                    line = line & " NOT NULL"
                End If
                
                'デフォルト値、シーケンスの指・
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
                
                'PrimaryKeyのセット
                If .Cells(y, 4) = "P" Then
                    line = line & " PRIMARY KEY"
                End If
                
                '次の行があるならコンマで続け・
                If .Cells(y + 1, 2) <> "" Then
                    line = line & ","
                End If
                
                
                fp.WriteLine (vbTab & line)
                y = y + 1
                If y > loopSafe Then
                    Exit Do
                End If
            Loop
            fp.WriteLine (");")
            fp.WriteLine ("")
            
            'INDEXの作・
            Do While .Cells(y, 2) <> "INDEX"
                y = y + 1
                If y > loopSafe Then
                    Exit Do
                End If
            Loop
            'Debug.Print .Cells(3, 3) & "line:" & y & .Cells(y, 2)
            y = y + 2
            Do Until .Cells(y, 2) = ""
                If .Cells(y, 6) = "Y" Then
                    line = "CREATE UNIQUE INDEX " & .Cells(y, 2) & " ON " & .Cells(3, 3) & " (" & .Cells(y, 3) & ");"
                Else
                    line = "CREATE INDEX " & .Cells(y, 2) & " ON " & .Cells(3, 3) & " (" & .Cells(y, 3) & ");"
                End If
                fp.WriteLine (line)
                y = y + 1
            Loop
            fp.WriteLine ("")
            fp.WriteLine ("")
            'Debug.Print "----" & .Cells(3, 3) & "作成"
    
        End With
        
        
    
    End If
    
    sheetCount = sheetCount + 1
    
    Loop
    
    '終・
    fp.Close
   

End Sub
