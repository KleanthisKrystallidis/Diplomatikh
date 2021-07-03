%*Kleanthis Krystallidis

:-module(depth_finder).


:-export(find_depth/3).

:-use_module(fd_prop_test_util).
:-use_module(game_description).
:-use_module(listut).
:-use_module(match_info).
:-use_module(payout).


find_depth(Role,State,Depth):-
	set_current_state(State),
	monte_carlo_payout(Role,State,0),
	get_depth(Depth1),
	set_current_state(State),
	monte_carlo_payout(Role,State,0),
	get_depth(Depth2),
	return_sum(Depth1,Depth2,Depth12),
	return_mean(Depth12,2,Depth3),
	Depth4 is Depth3 / 10,
	Depth5 is Depth3 - Depth4,
	round(Depth5,Depth6),
	integer(Depth6,Depth),
	set_current_state(State)
.



monte_carlo_payout(Role,State,Depth):-
	(terminal(State) ->
		set_depth(Depth)
	;
		Depth1 is Depth + 1,
		generate_random_actions(Role,State,Moves,_),
		update_current_state2(Moves,NewState),
		monte_carlo_payout(Role,NewState,Depth1)
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
	
return_mean(Summed_Data,Number_of_Data,Mean):-
	Mean is Summed_Data / Number_of_Data .
	
return_sum(X,Y,Z):-
	Z is X + Y.
	
:- local variable(depth, 0).
:- mode set_depth(++).
set_depth(V) :- setval(depth, V).
get_depth(V) :- getval(depth, V).
