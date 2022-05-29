Qnap::DownloadStation
=======

> NOTE: This library works with older QNAP NAS models that use QTS 4.x. Newer models are now being released with QTS 5.x, and most likely this library will not work with them. Patches welcome.

This gem provides an interface to the Download Station app that comes installed by default on many QNAP NAS.

It provides access to all available endpoints, but only a few have been documented.

If you can help document the endpoints, and provide example use cases, please feel free to send pull requests.

This software is an unofficial client for the QNAP api, and is not endorsed by QNAP. Future updates to your QNAP could possibly break the functionality of this library without warning.

Installation
-------

`gem install qnap-download_station`

Usage
-------

```ruby
# Download a Linux ISO from the web
require 'qnap/download_station'

ubuntu_iso = "http://de.releases.ubuntu.com/18.04/ubuntu-18.04-desktop-amd64.iso"

ds = Qnap::DownloadStation.new '192.168.1.100', 'username', 'password'
ds.task_add_url temp: 'Download', move: 'Multimedia/New', url: ubuntu_iso
active_downloads = ds.task_query
ds.logout
```

```ruby
# Alternative syntax to guarantee logout
# Start downloading a file over BitTorrent using a Magnet link

Qnap::DownloadStation.session('192.168.1.100', 'username', 'password') do |ds|
	magnet_link = "magnet:?xt=urn:btih:c12fe1c06bba254a9dc9f519b335aa7c1367a88a&dn"
	ds.task_add_url temp: 'Download', move: 'Multimedia/New', url: magnet_link
	pp ds.task_query
	# logout is automatically called, even if there was an exception
end

```

Alternatively, if the username and password are not provided, Qnap::DownloadStation will attempt to read them from environment variables.
```ruby
# ENV['QNAP_USERNAME']
# ENV['QNAP_PASSWORD']

ds = Qnap::DownloadStation.new '192.168.1.100'
# ...
ds.logout

# or...
Qnap::DownloadStation.session('192.168.1.100') do |ds|
	# ...
end
```

Available methods
-------

**Account methods**
* account_add
* account_query
* account_remove
* account_update

**Addon methods**
* addon_enable
* addon_install
* addon_query
* addon_search
* addon_uninstall
* addon_verify

**Config methods**
* config_get
* config_set

**Misc methods**
* misc_dir
* misc_env
* misc_login
* misc_logout
* misc_socks_5

**RSS methods**
* rss_add
* rss_add_job
* rss_query
* rss_query_feed
* rss_query_job
* rss_remove
* rss_remove_job
* rss_update
* rss_update_feed
* rss_update_job

**Tasks**
* task_add_torrent
* task_add_url
* task_detail
* task_get_file
* task_get_torrent_file
* task_pause
* task_priority
* task_query
* task_remove
* task_set_file
* task_start
* task_status
* task_stop

TODO
-------

* Document the endpoints
* Input validation
* Allow users to specify a SSL cert instead of just ignoring certificate errors
