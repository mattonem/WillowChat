Metacello new
 baseline:'WillowChat';
 repository: 'github://mattonem/WillowChat:master';
 load.
(Smalltalk at: #WillowChatApplication) start.
WorldState saveSession.
