#Mad Chatter

Mad Chatter is a fun, easy to customize chat server. It's written in Ruby and utilizes HTML 5 Web Sockets for fast communication.

##Getting Started

To get started, first install the Mad Chatter gem:

    gem install mad_chatter

Then generate the directory where your chat application will live:

    mad_chatter new mychatroom

This command will generate the following structure:

    mychatroom/
        config.rb
        extensions/
        web/
            index.html
            javascript.js
            stylesheets/
                reset.css
                styles.css

To start your chat server, navigate to the directory that was just created and run...

    mad_chatter start

This will start the web socket server on a specific port. You can now open the index.html file in your browser and start playing. All the files necessary to serve to the client are in the web directory. Feel free to copy/move these files if you'd prefer them somewhere else.

The start command will launch the web socket server in the background. You can use this command in production to start your server and leave it running. If you need to stop the server, simply run...

    mad_chatter stop


##Chat Actions

Hopefully, the default chatroom will be relatively intuitive to use. However, there are some extra features that Mad Chatter provides. Every chat message is parsed to see if it is a normal chat message, or if its a special action. These actions are much like IRC commands. For example, if I wanted to change my screen name from Andrew to Andy I could chat this message:

    /nick andy

Mad Chatter will interpret this message as an action and change the user name to andy.

If I wanted to embed a YouTube video for all the members of the chatroom to enjoy, I could type:

    /youtube http://youtu.be/n1NVfDlU6yQ

You can even create your own actions to do whatever you want.


##Customizing

The goal of Mad Chatter is to make it easy to create, host, and customize your own chat server. Let's take a look at the different ways you can customize your new chat server.

If you want to customize the html/css of your chatroom, you'll find them in the web directory.

There is an example config file that shows a few examples of things you can customize.

The extensions directory is for you to create your own chat actions. You can add your custom extensions by specifying them in the config file.


##Contributing

Please fork and send pull requests! Or submit issues if you have suggestions on how to improve.