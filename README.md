# Mad Chatter

Mad Chatter is a fun, easy to customize chat server. It's written in Ruby and utilizes HTML 5 Web Sockets for fast communication. It also has support for Markdown.

## Getting Started

To get started, first install the Mad Chatter gem:

    gem install mad_chatter

Then generate the directory where your chat application will live:

    mad_chatter new mychatroom

This command will generate the following structure:

    mychatroom/
        config.rb
        extensions.rb
        web/
            index.html
            styles.css
            mad_chatter.js
            mad_chatter_actions.js

To start your chat server, navigate to the directory that was just created and run...

    mad_chatter start

This will start the web socket server on a specific port. You can now open the index.html file in your browser and start playing. All the files necessary to serve to the client are in the web directory. Feel free to copy/move these files if you'd prefer them somewhere else.

The start command will launch the web socket server in the background. You can use this command in production to start your server and leave it running. If you need to stop the server, simply run...

    mad_chatter stop

## Chat Actions

Hopefully, the default chatroom will be relatively intuitive to use. However, there are some extra features that Mad Chatter provides. Every chat message is parsed to see if it is a normal chat message, or if its a special action. These actions are much like IRC commands. For example, if I wanted to change my screen name from Andrew to Andy I could chat this message:

    /nick andy

Mad Chatter will interpret this message as an action and change the user name to andy.

If I wanted to embed a YouTube video for all the members of the chatroom to enjoy, I could type:

    /youtube http://youtu.be/n1NVfDlU6yQ

Or if I wanted to shake everyone's chat window:

    /earthquake

You can also create your own actions to do whatever you want.


## Customizing

The goal of Mad Chatter is to make it easy to create, host, and customize your own chat server. Let's take a look at the different ways you can customize your new chat server.

If you want to customize the html/css of your chatroom, you'll find it in the web directory.

There is an example config file that shows a few examples of things you can customize.

The extensions.rb file is for you to create your own chat extensions. You will find a few examples in that file.


## Mac, Windows, and Linux Wrappers

Once you've got your chat server running and being used by other people, you might be interested in using/distributing an installable application, so you can leave it running and don't need to pull it up in a browser anymore. Here's a list of the currently available GUI wrapper applications:

 * [Mad Chatter for Mac](https://github.com/andrewhavens/mad_chatter_for_mac) (a MacRuby app based on WebKit)

## Getting Help / Providing Feedback

Feel free to submit a GitHub issue, or post to the [Google Group](https://groups.google.com/group/mad-chatter), or send me a message on GitHub.

You can also vote on upcoming features: https://madchatter.uservoice.com

## Contributing

Please fork and send pull requests! Or submit issues if you have suggestions on how to improve.

## TODO

 - Maybe add support for alternative web socket servers like Juggernaut, Socket.io, or Cramp and web-socket-js

##Copyright

Copyright (c) 2011-2012 Andrew Havens. MIT license. See LICENSE.txt for further details.
