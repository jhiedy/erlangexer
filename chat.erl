-module(chat).
-compile(nowarn_export_all).
-compile(export_all).

init_chat() ->
    User1Name = io:get_line("Enter your name: "),
    register (user1, spawn(chat, user1, [User1Name])).

user1(User1Name) ->
    receive
        {Message, SenderName} ->
            case Message of
                bye -> endchat();
                _ -> io:format("~s: ~s",[SenderName, Message])
            end,
        {user2, User2_Pid} ->
            chat(User2_Pid, User1Name)
    end,
    user1(User1Name).

init_chat2(User1_Node) ->
    User2Name = io:get_line("Enter Your Name: "),
	spawn(chat, user2, [User1_Node, User2Name]).

user2(User1_Node, User2Name) ->
    {user1, User1_Node} ! {user2, self()},
    chat(User1_Node, User2Name),
    user2(User2Name).
user2(User2Name) ->
    receive
        {Message, SenderName} ->
            case Message of
                bye -> endchat();
                _ -> io:format("~s: ~s",[SenderName, Message])
            end,
    end,
    user2(User2Name).

chat(To, SenderName) ->
    Message = io:get_line("You: "),
	To ! {Message, SenderName}
    case Message of 
        bye -> exit(normal);
        _ -> chat(To, SenderName)
    end.

endchat() ->
    io:format("Your partner disconnected.").
