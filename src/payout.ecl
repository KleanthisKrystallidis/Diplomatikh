:-module(payout).

:-use_module(fd_prop_test_util).
:-use_module(game_description).
:-use_module(listut).
:-use_module(match_info).

:-export(monte_carlo_call0/4).
:-export(opponent_role/2).
:-export(update_current_state2/2).


monte_carlo_call0(Role,State,Number_of_tries,Best_Score):-
	(terminal(State) ->	
		goal(Role,Best_Score,State)
	;
		set_move_id_list([]),
		set_scores([]),
		/* monte_carlo_search(Role,State,Number_of_tries,Best_Score) */
		(
		param(State),
		param(Role),
		for(_I,1,Number_of_tries) do 
			set_current_state(State),
			monte_carlo_payout(Role,State,Score_List),
			nth1(2,Score_List,Score),
			get_score_sum(Summing),
			return_sum(Summing,Score,New_Summing),
			set_score_sum(New_Summing)
		)
		,get_score_sum(Summed),
		set_score_sum(0),
		return_mean(Summed,Number_of_tries,Best_Score)
	).

return_sum(X,Y,Z):-
	Z is X + Y.

return_mean(Summed_Data,Number_of_Data,Mean):-
	Mean is Summed_Data / Number_of_Data .
	
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
	