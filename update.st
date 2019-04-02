Metacello new
 baseline:'WillowChat';
 repository: 'github://mattonem/WillowChat:master/src';
 load.
(Smalltalk at: #SanboxRoot) start.
WorldState saveSession.
