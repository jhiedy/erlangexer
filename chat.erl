-module(chat).
-compile(nowarn_export_all).
-compile(export_all).

init_chat() ->
	User1Name = io:get_line('Name please: '),
	register (user1, spawn(chat ,user1,[User1Name])).

user1(User1Name) ->
	receive
		finished ->
			io:format("Your partner disconnected.");
		{user2, User2_Pid} ->
			User2_Pid ! {user1, self()},
			user1(sendmessage, User2_Pid, User1Name);
		{Message2,User2Name} ->
			io:format("~s: ~s",[User2Name,Message2])
	end.

user1(sendmessage,User2_Pid, User1Name) ->
	Message1 = io:get_line("You: "),
	User2_Pid ! {Message1,User1Name},
	user1(sendmessage, User2_Pid, User1Name).

init_chat2(User1_Node) ->
	User2Name = io:get_line('Name please: '),
	spawn(chat, user2, [start,User1_Node, User2Name]).

user2(bye, User1_Node) ->
	{user1, User1_Node} ! finished.

user2(start, User1_Node, User2Name) ->
	{user1, User1_Node} ! {user2, self()},
	receive
		finished ->
			io:format("Your partner disconnected.");
		{user1, User1_Node} ->
			user2(sendmessage, User1_Node, User2Name);
		{Message1,User1Name} ->
			io:format("~s: ~s",[User1Name,Message1])
	end;
user2(sendmessage,User1_Node, User2Name) ->
	Message2 = io:get_line("You: "),
	{user1,User1_Node} ! {Message2,User2Name},
	user2(sendmessage, User1_Node, User2Name).


% init_chat2(User1_Node, User1Name) ->
% 	User2Name = io:get_line('Name please: '),
% 	spawn(chat, user2, [3,User1_Node, User1Name, User2Name]).

% user2(0, User1_Node, User1Name, User2Name) ->
% 	{user1, User1_Node} ! finished,
% 	io:format("~s finished", [User2Name]);
% user2(N, User1_Node, User1Name, User2Name) ->
% 	{user1, User1_Node} ! {user2, User2Name, self()},
% 	receive
% 		user1 ->
% 			io:format("~s got ~s~n", [User2Name, User1Name])
% 	end,
% 	user2(N-1,User1_Node, User1Name, User2Name).