# GetIt @ NYU
The GetIt application at NYU leverages Umlaut to provide just in time OpenURL resolution (I'm not sure what that means though).

Umlaut aggregates services for a requested citation represented by an Open URL.  That's a little better, but you should probably
just check out [Umlaut](http://github.com/team-umlaut/umlaut).

## NYU Customizations
At NYU we've implemented a few features in GetIt @ NYU that aren't in your basic Umlaut application.

1. Aleph Integration: we've included some Aleph functionality, most notably the ability to request Aleph items
2. SFX Solr Indexing: we've indexed SFX titles in Solr for quick retrieval using [Sunspot](http://sunspot.github.com/)
3. User Login: we've included the ability for users to login via PDS, using [Authlogic](http://github.com/binarylogic/authlogic), [authpds](http://github.com/scotdalton/authpds) and [authpds-nyu](http://github.com/scotdalton/authpds)
4. UI: we've customized the UI to our liking leveraging [Twitter Bootstrap](http://twitter.github.com/bootstrap) where appropriate.