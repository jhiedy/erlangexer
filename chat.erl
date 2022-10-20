-module(chat).
-compile(nowarn_export_all).
-compile(export_all).

init_chat() ->
	User1Name = io:get_line('Name please: '),
	register (user1, spawn(chat ,user1,[User1Name])).
	

user1(User1Name) ->
	receive
		finished ->
			io:format("~s finished ~n", [User1Name]);
		{user2, User2Name, User2_Pid} ->
			io:format("~s got ~s ~n", [User1Name, User2Name]),
			User2_Pid ! user1,
			user1(User1Name)
	end.

init_chat2(User1_Node, User1Name) ->
	User2Name = io:get_line('Name please: '),
	spawn(chat, user2, [3,User1_Node, User1Name, User2Name]).

user2(0, User1_Node, User1Name, User2Name) ->
	{user1, User1_Node} ! finished,
	io:format("~s finished", [User2Name]);
user2(N, User1_Node, User1Name, User2Name) ->
	{user1, User1_Node} ! {user2, User2Name, self()},
	receive
		user1 ->
			io:format("~s got ~s~n", [User2Name, User1Name])
	end,
	user2(N-1,User1_Node, User1Name, User2Name).