:- module(random_move).


:-export(usable_position_generator/3).
:-export(opponent_role/2).
:-export(update_current_state2/2).

:-use_module(match_info).
:-use_module(game_description).
:-use_module(fd_prop_test_util).
:- use_module(listut).
:-use_module(monte_carlo).



usable_position_generator(Role,State,Number_of_Sequences):- % K number of states in sequence,J distance between them
	(
	param(Role),
	param(State),
	for(_I,1,Number_of_Sequences) do
		make_random_moves(Role,State,3),
		set_subseq_list([]),
		(terminal(State) ->
		(	
			goal(Role, MyValue, State),
			get_subseq_list(Sulist),
			get_seq_list(Selist),
			append([MyValue],Sulist,Subseqlist),
			append([Subseqlist],Selist,Sequencelist),
			set_seq_list(Sequencelist)
		)
		;
		(
			random_int_between(2,3,K),    % number of states in subsequence
			(
			param(Role),
			for(_P,1,K) do
				random_int_between(1,3,J),            %number of moves between kept states
				get_current_state(NewState),
				get_subseq_list(Slist),
				append([NewState],Slist,Sublist),
				set_subseq_list(Sublist),
				make_random_moves(Role,NewState,J)
			
			),
			get_current_state(NewState2),
			monte_carlo_call(Role,NewState2,10,Score),
			get_subseq_list(Sulist),
			get_seq_list(Selist),
			append([Score],Sulist,Subseqlist),
			append([Subseqlist],Selist,Sequencelist),
			set_seq_list(Sequencelist)
		)
		)
	).


% fix initial state return

make_random_moves(Role,State,Number_of_Moves):-
opponent_role(Role,OpRole),
set_current_state(State),
(
param(Role),
param(OpRole),
for(_O,1,Number_of_Moves) do 
	get_current_state(State),
	(terminal(State) ->
		true
	;
	(
		findall(Move,legal(Role,Move,State),Move_List),
		length(Move_List,Leng),
		random_int_between(1,Leng,I),
		nth1(I,Move_List,Move),
		findall(OpMove,legal(OpRole,OpMove,State),OpMove_List),
		length(OpMove_List,OpLeng),
		random_int_between(1,OpLeng,J),
		nth1(J,OpMove_List,OpMove),
		append([OpMove],[Move],Moves),
		update_current_state2(Moves,NewState),
		set_current_state(NewState)
	)
	)
).



update_current_state2(Moves, CurrentState) :-
	get_current_state(LastState),
	get_our_role(Role),
	(Moves\=[] ->
		does(Role, _OurMove, Moves), !,
		state_update(LastState, Moves, CurrentState),
		set_current_state(CurrentState)
	;
		% this is the case for the first play-message (no prior moves)
		CurrentState=LastState
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
	

