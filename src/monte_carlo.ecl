:- module(monte_carlo).

:-use_module(fd_prop_test_util).
:-use_module(game_description).
:-use_module(listut).
:-use_module(match_info).

:-export(monte_carlo_call/4).

score([],0,0).

monte_carlo_call(Role,State,Number_of_tries,Best_Score):-
	(terminal(State) ->	
		goal(Role,Best_Score,State)
	;
		set_move_id_list([]),
		set_scores([]),
		monte_carlo_search(Role,State,Number_of_tries,Best_Score)
	).


monte_carlo_search(Role,State,Number_of_tries,Best_Score):-
	(
	param(Role),
	param(State),
	for(_I,1,Number_of_tries) do 
		generate_random_actions(Role,State,Moves,Move),    
		set_current_state(State),
		update_current_state2(Moves,NewState),
		monte_carlo_payout(Role,NewState,Score_List),
		set_move_id([]),
		append([Move],State,MoveId),
		get_move_id_list(MoveId_List),
		append([MoveId],MoveId_List,M_List),
		set_move_id_list(M_List),
		(check_move_not_new(MoveId,Score,Times)->
			nth1(2,Score_List,MyScore),
			sumer(Score,MyScore,Score_Sum),
			increment(Times,NTimes),
			get_scores(Ini_Score_List),
			remove_element(MoveId,Ini_Score_List,Result_List),
			functor(Score_Term,score,3),
			arg(1,Score_Term,MoveId),
			arg(2,Score_Term,Score_Sum),
			arg(3,Score_Term,NTimes),
			set_scores([Score_Term|Result_List])
			
		
		%update score,times
		;
			functor(Score_Term,score,3),
			nth1(2,Score_List,MyScore),
			arg(1,Score_Term,MoveId),
			arg(2,Score_Term,MyScore),
			arg(3,Score_Term,1),
			get_scores(Multi_Score),
			append([Score_Term],Multi_Score,Temp),
			set_scores(Temp)
		)
	),
	compute_move(Best_Score).

remove_element(MoveId,Sc_List,New_Score_List):-
	(
	param(MoveId),
	foreach(Sc,Sc_List),
	fromto(New_Score_List,Out,In,[]) do
		arg(1,Sc,Id),MoveId == Id -> 
		Out=In
	; 
		Out=[Sc|In]
	
	).
			
		

	
check_move_not_new(MoveId,Score2,Times):-
	get_scores(Score_List2),
	(Score_List2 \== [] ->
		(
		param(MoveId),
		param(Score2),
		param(Times),
		foreach(Sc,Score_List2) do
			score_check(Sc,MoveId,Score2,Times)
			;
			true
		)
	;
		false
	),nonvar(Score2),nonvar(Times).
	

score_check(Sc,MoveId,Score,Times):-
	(arg(1,Sc,MoveId2),MoveId2 == MoveId ->
		arg(2,Sc,Score),
		arg(3,Sc,Times)
	;
		false
	).

compute_move(Best_Qa):-
		get_move_id_list(MoveId_List),
		get_scores(Score_terms),
		(
		param(Score_terms),
		foreach(MoveId,MoveId_List) do
			(
			param(MoveId),
			foreach(IndScore,Score_terms) do 
				(
					score_check(IndScore,MoveId,Score,Times) ->
					(
						compute_qa(Score,Times,Qa),
						get_maxi(Maximum),									%Improve by taking into account the times if all else is equal
							(
							( Qa > Maximum )->
								set_maxi(Qa),
								set_idmaxi(MoveId)
							;
								true
							)
					)
					;
					(
						true
					)
				)
			)
		),
		get_maxi(Best_Qa)
		%,headcutter(Moveid,Move)
		.
			
			

increment(X,Xs):-
	Xs is X + 1.

sumer(X,Y,Xs):-
	Xs is X + Y.
	
compute_qa(X,Y,Qa):-
	Qa is X / Y .

headcutter([H|_],M):-
	H = M.
	


monte_carlo_payout(Role,State,Score_List):-
	(terminal(State) ->
		opponent_role(Role,OpRole),
		goal(Role, MyValue, State),
		goal(OpRole, OpValue, State),
		append([Role],[MyValue],Myscore),
		append([OpRole],[OpValue],Opscore),
		append(Myscore,Opscore,Score_List)
	;
		generate_random_actions(Role,State,Moves,_),
		update_current_state2(Moves,NewState),
		monte_carlo_payout(Role,NewState,Score_List)
	).
	
opponent_role(OurRole,OpRole):-
roles(Roles),
length(Roles,Len),
(
param(OpRole),
param(OurRole),
param(Roles),
	for(I,1,Len) do 
	nth1(I,Roles,PoRole),
	(OurRole \= PoRole ->
		OpRole = PoRole
	;
	true
	)
).	

	
	
generate_random_actions(Role,State,Moves,Move):-
	opponent_role(Role,OpRole),
	findall(Move,legal(Role,Move,State),Move_List),
	length(Move_List,Leng),
	random_int_between(1,Leng,I),
	nth1(I,Move_List,Move),
	findall(OpMove,legal(OpRole,OpMove,State),OpMove_List),
	length(OpMove_List,OpLeng),
	random_int_between(1,OpLeng,J),
	nth1(J,OpMove_List,OpMove),
	append([OpMove],[Move],Moves).
	
update_current_state2(Moves, CurrentState) :-
	get_current_state(LastState),
	get_our_role(Role),
	(Moves\=[] ->
		does(Role, _OurMove, Moves,C_Moves), !,
		state_update(LastState, C_Moves, CurrentState),
		set_current_state(CurrentState)
	;
		% this is the case for the first play-message (no prior moves)
		CurrentState=LastState
	).
	
