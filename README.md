# Mad Chatter

Mad Chatter is a fun, easy to customize chat server. It's written in Ruby and utilizes HTML 5 Web Sockets for fast communication.

The goal of Mad Chatter is to basically become an open-source version of [Campfire](http://campfirenow.com/), [HipChat](https://www.hipchat.com), or [FlowDock](https://www.flowdock.com)...or at least use those as inspiration.

## Getting Started

Since Mad Chatter is written in Ruby, you'll need to install Ruby in order to continue. We have a wiki page to help you with that:

[How to install Ruby and RubyGems](https://github.com/andrewhavens/mad_chatter/wiki/How-to-install-Ruby-and-RubyGems)

Once you have RubyGems installed, you can install the Mad Chatter gem:

    gem install mad_chatter

Then generate the directory where your chat application will live:

    mad_chatter new mychatroom

This command will generate the following structure:

    mychatroom/
        config.yml      # for general configuration
        extensions/     # for writing your own extensions
        web/            # all of the html, css, and javascript live here

To start your chat server, navigate to the directory that was just created and run...

    mad_chatter preview

This will start up the Mad Chatter chat server as well as a simple web server for you to preview/demo your new chat room. Now you can check it out by opening http://localhost:3000 in your browser. You should see something like this:

![Mad Chatter screenshot](https://raw.github.com/andrewhavens/mad_chatter/master/screenshot.png)

When you're ready to have other people start using your new chat server (friends, family, co-workers, etc) you'll need to set up a web server so other people can access it. Set up your web server to serve the `web` directory that we created above. Now you're ready to start Mad Chatter and leave it running in the background. Here are a few useful commands for that:

    mad_chatter start
    mad_chatter stop
    mad_chatter restart

## Chat Actions

Mad Chatter can do some special things depending on the chat messages you send. Every chat message is parsed to see if it is a normal chat message, or if it's a special action. These actions are much like IRC commands. For example, if I wanted to change my name from Andrew to Andy I could chat this message:

    /nick andy

Mad Chatter will interpret this message as an action and change the user name to andy.

If I wanted to embed a YouTube video for all the members of the chatroom to enjoy, I could type:

    /youtube http://youtu.be/n1NVfDlU6yQ

Or if I wanted to shake everyone's chat window:

    /earthquake

You can even create your own actions!


## Customizing

The goal of Mad Chatter is to make it easy to create, host, and customize your own chat server. Let's take a look at the different ways you can customize your new chat server.

All of the HTML, CSS, and Javascript is available for you to customize in the `web` directory.

In the `config.yml` file you can see a few things you can customize.

The `extensions` directory contains all of your extensions. If you wanted to create a custom action, this is where you would put it. You will find a few examples in that directory.


## Mac, Windows, and Linux Wrappers

Once you've got your chat server running and being used by other people, you might be interested in using and distributing an installable application so your users have the convenience of clicking on an icon, receiving growl notifications, etc. Here's a list of the currently available "wrapper" applications:

 * [Mad Chatter for Mac](https://github.com/andrewhavens/mad_chatter_for_mac)

## Getting Help / Providing Feedback

If you need help or have feedback, feel free to submit bug reports and feature requests to our [GitHub Issues page](https://github.com/andrewhavens/mad_chatter/issues), or post to the [Google Group](https://groups.google.com/group/mad-chatter).

You can also vote on upcoming features: https://madchatter.uservoice.com

## Contributing

Please fork and send pull requests! Or submit issues if you have suggestions on how to improve Mad Chatter.
[![Build Status](https://secure.travis-ci.org/andrewhavens/mad_chatter.png)](http://travis-ci.org/andrewhavens/mad_chatter)

##Copyright

Created by Andrew Havens and released under the MIT license.
