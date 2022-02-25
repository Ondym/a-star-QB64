Dim grid(32, 20, 5) As Integer
'(x, y, [Gcost, Hcost, Fcost, Opened/Block, parent])
Dim done As Integer
Dim startX, startY, endX, endY As Integer
Dim colors(5) As Integer

colors(0) = 0: colors(1) = 2: colors(2) = 4: colors(3) = 15: colors(4) = 14

Screen 7
'$ExeIcon:'C:\Users\ondra\Documents\Programming\bas\astar.ico'
_Icon
_Title "A* Algorithm"
_FullScreen

Color 10
Print: Print: Print
Print "          Input starting cords"
Input "                ", startX, startY
Print "         Input finishing cords"
Input "                ", endX, endY

If startX > 31 Or startX < 0 Then
    startX = 0
End If
If startY > 19 Or startY < 0 Then
    startY = 0
End If
If endX > 31 Or endX < 0 Then
    endX = 31
End If
If endY > 19 Or endY < 0 Then
    endY = 19
End If

Cls
done = 0

For X = 0 To 32: For Y = 0 To 20
    Line (X * 10, Y * 10)-((X + 1) * 10, (Y + 1) * 10), 15, B
Next: Next
Line (startX * 10 + 3, startY * 10 + 3)-(startX * 10 + 7, startY * 10 + 7), 14, BF
Line (endX * 10 + 3, endY * 10 + 3)-(endX * 10 + 7, endY * 10 + 7), 9, BF

Do
    Do While _MouseInput And _MouseButton(1) = -1
        X = Int(_MouseX / 10)
        Y = Int(_MouseY / 10)
        If Not X + Y * 100 = startX + startY * 100 And Not X + Y * 100 = endX + endY * 100 Then
            grid(X, Y, 3) = 3
            Line (X * 10, Y * 10)-((X + 1) * 10, (Y + 1) * 10), colors(grid(X, Y, 3)), BF
        End If
    Loop
    pause .5
Loop Until InKey$ <> ""

grid(startX, startY, 3) = 1
grid(startX, startY, 1) = getHCost(startX, startY, endX, endY)
grid(startX, startY, 2) = 0

Do
    bestValue = 9999999
    bestX = -1: bestY = -1

    done = done * 2

    For X = 0 To 31
        For Y = 0 To 19
            If grid(X, Y, 3) = 1 And grid(X, Y, 2) < bestValue Then
                bestValue = grid(X, Y, 2)
                bestX = X: bestY = Y

            End If
            Line (X * 10, Y * 10)-((X + 1) * 10, (Y + 1) * 10), colors(grid(X, Y, 3)), BF
            Line (X * 10, Y * 10)-((X + 1) * 10, (Y + 1) * 10), 15, B
        Next
    Next


    If bestX = endX And bestY = endY Then
        done = 1
        xx = endX: yy = endY
        Do
            grid(xx, yy, 3) = 4
            xxx = grid(xx, yy, 4) Mod 32
            yy = Int(grid(xx, yy, 4) / 32)
            xx = xxx
        Loop Until xx = startX And yy = startY
    End If

    If bestX < 0 Then
        done = 2
        Color 4
        Print "no possible path"
    End If

    If done = 0 Then
        X = bestX
        Y = bestY
        For i = -1 To 1
            For j = -1 To 1
                If Not i + j * 2 = 0 Then
                    If X + i > -1 And Y + j > -1 And X + i < 32 And Y + j < 20 Then
                        'Print X + i, Y + j
                        suggestedGcost = 0
                        If Abs(i) = Abs(j) Then
                            suggestedGcost = grid(X, Y, 0) + 14
                        Else:
                            suggestedGcost = grid(X, Y, 0) + 10
                        End If

                        If grid(X + i, Y + j, 3) = 0 Or ((grid(X + i, Y + j, 3) = 1 And grid(X + i, Y + j, 0) > suggestedGcost)) Then

                            grid(X + i, Y + j, 0) = suggestedGcost
                            grid(X + i, Y + j, 1) = getHCost(X + i, Y + j, endX, endY)
                            grid(X + i, Y + j, 2) = grid(X + i, Y + j, 0) + grid(X + i, Y + j, 1)
                            grid(X + i, Y + j, 3) = 1
                            grid(X + i, Y + j, 4) = X + Y * 32
                        End If
                    End If
                End If
            Next
        Next
    End If

    If (done < 2) Then
        grid(bestX, bestY, 3) = 2
    End If

    Line (startX * 10 + 3, startY * 10 + 3)-(startX * 10 + 7, startY * 10 + 7), 14, BF
    Line (endX * 10 + 3, endY * 10 + 3)-(endX * 10 + 7, endY * 10 + 7), 9, BF

    pause 5
Loop While done < 2

'Do: Loop

Sub pause (time As Long)
    For i = 0 To time * 1000000
    Next i
End Sub

Function getHCost (xx As Integer, yy As Integer, endX, endY)
    If Abs(xx - endX) > Abs(yy - endY) Then
        getHCost = Abs(endY - yy) * 14 + Abs(endX - xx - Abs(endY - yy)) * 10
    Else
        getHCost = Abs(endX - xx) * 14 + Abs(endY - yy - Abs(endX - xx)) * 10
    End If

    'pause 500000
End Function
