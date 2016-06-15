<%
	sql = "SELECT g.golfer_id, e.event_id, s.front_nine, s.back_nine, c.course_rating, c.slope_rating FROM golfer g INNER JOIN score s ON s.golfer_id = g.golfer_id INNER JOIN event e ON e.event_id = s.event_id INNER JOIN course c ON c.course_id = e.course_id ORDER BY g.golfer_id ASC, e.event_id ASC"
	rs.Open sql
	If Not rs.EOF Then
		aScores = rs.GetRows()
	End If
	rs.Close()
	
	Function GetAverageRound(g)
		Dim out : out = 0
		
		Dim sum : sum = 0
		Dim rounds : rounds = 0
		If IsArray(aScores) And UBound(aScores) > 0 Then
			For gari = LBound(aScores,2) to UBound(aScores,2)
				If CInt(aScores(0,gari)) = CInt(g) Then
					If CInt(aScores(2,gari)) > 0 Then
						sum = sum + CLng(aScores(2,gari))
						rounds = rounds + 1
					End If
					
					If CInt(aScores(3,gari)) > 0 Then
						sum = sum + CLng(aScores(3,gari))
						rounds = rounds + 1
					End If
				End If
			Next
			
			If rounds > 0 Then
				out = CDbl(sum / rounds)
			End If
		End If
		
		GetAverageRound = Round(out,1)
	End Function
	
	Function GetRoundsPlayed(g)
		Dim out : out = 0
		
		If IsArray(aScores) Then
			For grpi = LBound(aScores,2) To UBound(aScores,2)
				If CInt(aScores(0,grpi)) = CInt(g) Then
					If CInt(aScores(2,grpi)) > 0 Then
						out = out + 1
					End If
					If CInt(aScores(3,grpi)) > 0 Then
						out = out + 1
					End If
				End If
			Next
		End If
		
		GetRoundsPlayed = out
	End Function

	Function GetScore(g, e)
		Dim out : out = "0-0"
		If IsArray(aScores) Then
			For gsi = LBound(aScores,2) To UBound(aScores,2)
				If CInt(aScores(0,gsi)) = CInt(g) Then
					If CInt(aScores(1,gsi)) = CInt(e) Then
						out = aScores(2,gsi) & "-" & aScores(3,gsi)
						Exit For
					End If
				End If
			Next
		End If
		GetScore = out
	End Function
	
	Function GetHandicap(g)
		Dim out : out = "0"
		
		ReDim aDiffs(0)
		
		out = UBound(aDiffs)
		
		If IsArray(aScores) Then
			For ghi = LBound(aScores,2) To UBound(aScores,2)
				If CInt(aScores(0,ghi)) = CInt(g) Then
					'front nine
					If CInt(aScores(2, ghi)) > 0 Then
						aDiffs(UBound(aDiffs)) = GetDifferential(aScores(2,ghi), Round(CDbl(aScores(4,ghi))/2, 1), aScores(5,ghi))
						ReDim Preserve aDiffs(UBound(aDiffs)+1)
					End If
					
					'back nine
					If CInt(aScores(3, ghi)) > 0 Then
						aDiffs(UBound(aDiffs)) = GetDifferential(aScores(3,ghi), Round(CDbl(aScores(4,ghi))/2, 1), aScores(5,ghi))
						ReDim Preserve aDiffs(UBound(aDiffs)+1)
					End If
				End If
			Next
		End If
		
		'differentials table
		'rounds		diffs
		'5-6		1
		'7-8		2
		'9-10		3
		'11-12		4
		'13-14		5
		'15-16		6
		'17			7
		'18			8
		'19			9
		'20+		10
		Call Sort(aDiffs)
		
		Dim lo : lo = LBound(aDiffs)
		Select Case CInt(UBound(aDiffs)+1)
			Case 5, 6
				hi = 0
			Case 7, 8
				hi = 1
			Case 9, 10
				hi = 2
			Case 11, 12
				hi = 3
			Case 13, 14
				hi = 4
			Case 15, 16
				hi = 5
			Case 17
				hi = 6
			Case 18
				hi = 7
			Case 19
				hi = 8
			Case CInt(UBound(aDiffs)+1)> 20
				hi = 9
			Case Else
				hi = UBound(aDiffs)
		End Select
		
		'fix until actual handicap calc is fixed
		lo = LBound(aDiffs)
		hi = UBound(aDiffs)
		out = .96 * GetAverageDifferential(aDiffs, lo, hi)
		
		GetHandicap = Round(out,1)
	End Function
	
	Function GetDifferential(score, course, slope)
		Dim out : out = 0
		out = ((CDbl(score) - CDbl(course)) * 113) / CDbl(slope)
		GetDifferential = Round(out,1)
	End Function
	
	Function GetAverageDifferential(a, l, h)
		Dim sum : sum = 0.0
		Dim out : out = 0
		If IsArray(a) And h > 0 Then
			For gadi = l to h
				sum = sum + CDbl(a(gadi))
			Next
			
			out = CDbl(sum / (h-l))
		End If
				
		GetAverageDifferential = Round(out,1)
	End Function
	
	Function Sort(a)
		For si = UBound(a)-1 To 0 Step -1
			For sj = 0 to si
				If CDbl(a(sj)) > CDbl(a(sj+1)) Then
					temp = a(sj+1)
					a(sj+1) = a(sj)
					a(sj) = temp
				End If
			Next
		Next
	End Function
%>