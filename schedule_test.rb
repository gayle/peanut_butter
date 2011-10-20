require_relative 'schedule'
require 'test/unit'
require 'rack/test'
require 'sinatra'
require 'flexmock/test_unit'

ENV['RACK_ENV'] = 'test'

class ScheduleTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_does_something
    get '/'
    assert last_response.ok?, "expected 200 response, got #{last_response.status}"
    assert !last_response.body.empty?, "response should have some content"
  end

  def test_when_no_data_found
    fake_document = flexmock(Nokogiri::HTML::Document)
    flexmock(fake_document).should_receive(:css).and_return([])
    flexmock(Nokogiri).should_receive(:HTML).and_return(fake_document)

    get '/'
    assert last_response.ok?, "expected 200 response, got #{last_response.status}"
    assert_match /no events found/i, last_response.body
  end

  def test_when_data_found
    setup_flexmock_nokogiri_html_doc()
    get '/?date=2011-10-19'
    assert last_response.ok?, "expected 200 response, got #{last_response.status}"
    assert_match /<event>/i, last_response.body
  end

  def test_stick_and_puck_data
    setup_flexmock_nokogiri_html_doc()
    get '/StickAndPuck?date=2011-10-19'
    assert last_response.ok?, "expected 200 response, got #{last_response.status}"
    assert_match /<event>/, last_response.body
    assert_match /Stick And Puck/i, last_response.body
  end


  private
  
  def setup_flexmock_nokogiri_html_doc
    doc = Nokogiri::HTML(html_source_for_test())
    assert_equal 63, doc.css('tr[@class = "2011-10-19"]').count, "this HTML should have 63 rows that match the date"
    flexmock(Nokogiri).should_receive(:HTML).and_return(doc)
    doc
  end

  # This was a view-source from the actual website
  def html_source_for_test
    %{
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Daily Rink Schedule | The Chiller Ice Rinks</title>
	<meta name="author" content="huber+co. http://huberandco.com/">

	<link rel="stylesheet" href="http://www.thechiller.com/media/stylesheets/main.css" type="text/css" media="screen" title="Default" charset="utf-8">
	<link rel="stylesheet" href="http://www.thechiller.com/media/stylesheets/superfish.css" type="text/css" media="screen" charset="utf-8">
	<link rel="stylesheet" href="http://www.thechiller.com/media/stylesheets/superfish-navbar.css" type="text/css" media="screen" charset="utf-8">

	<!--[if lte IE 6]><link rel="stylesheet" href="http://www.thechiller.com/media/stylesheets/ie6.css" type="text/css" media="screen" charset="utf-8"><![endif]-->

	<!--[if gte IE 7]><link rel="stylesheet" href="http://www.thechiller.com/media/stylesheets/ie.css" type="text/css" media="screen" charset="utf-8"><![endif]-->

	<script src="http://www.thechiller.com/media/javascript/jquery-1.4.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="http://www.thechiller.com/media/javascript/jquery.cycle.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="http://www.thechiller.com/media/javascript/hoverIntent.js" type="text/javascript" charset="utf-8"></script>
	<script src="http://www.thechiller.com/media/javascript/jquery.bgiframe.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="http://www.thechiller.com/media/javascript/superfish.js" type="text/javascript" charset="utf-8"></script>

	<script src="http://www.thechiller.com/media/javascript/jquery.defaultvalue.js" type="text/javascript" charset="utf-8"></script>

	<script type="text/javascript" charset="utf-8">
		$(function() {
			$('#nav ul.main li.current ul').show();
			$('#nav ul.main').superfish( { pathClass: 'current', pathlevels: 1, autoArrows: true } );
			$('table.schedule tr:even').addClass('zebra'); $('table.schedule tr').hover(function() { $(this).toggleClass('hover') }, function() { $(this).toggleClass('hover') });
			$('#search').defaultvalue('Search this site');
		});
	</script>

	<script type="text/javascript" charset="utf-8">
		$(function() {
			$('iframe').attr('frameborder', 0);
		});
	</script>

	<link rel="alternate" type="application/rss+xml" href="http://www.thechiller.com/news/feed" title="News RSS">
<link rel="alternate" type="application/rss+xml" href="http://www.thechiller.com/events/feed" title="Events RSS">

</head>
<body class="homepage">
	<div class="container">

		<div id="header">
			<div id="utility-nav">
				<ul class="utility"><li class="first-child "><a href="http://www.thechiller.com/" title="Home" class="">Home</a></li><li class=""><a href="http://www.thechiller.com/locations" title="Locations" class="">Locations</a></li><li class=""><a href="http://www.thechiller.com/contact-us" title="Contact Us" class="">Contact Us</a></li><li class=""><a href="http://www.thechiller.com/events" title="Events" class="">Events</a></li><li class=""><a href="http://www.thechiller.com/about-us" title="About Us" class="">About Us</a></li><li class=""><a href="http://www.thechiller.com/parties-and-events" title="Parties &amp; Events" class="">Parties & Events</a></li><li class="last-child "><a href="http://www.thechiller.com/blog" title="Chiller Blog" class="">Chiller Blog</a></li></ul>			</div>	<!-- /utility-nav -->

			<form id="site-search" action="http://www.thechiller.com/search">

				<div>
					<input type="hidden" name="cx" value="015624241733564626900:pyi_a8yxp-y">
					<input type="hidden" name="cof" value="FORID:10;NB:1">
					<input type="hidden" name="ie" value="UTF-8">

					<label for="search">Search</label><input type="text" name="q" value="Search this site" id="search">
					<button type="submit">Search</button>
				</div>
			</form>


			<a href="http://www.thechiller.com/" title="Return to The Chiller homepage"><img src="http://www.thechiller.com/media/images/chiller-logo.png" alt="The Chiller" id="logo" width="202" height="184"></a>
			<img src="http://www.thechiller.com/media/images/tagline.png" alt="The coolest place for family fun in Columbus" id="tagline">

			<div id="nav">
				<ul class="main"><li class="first-child "><a href="http://www.thechiller.com/hockey" title="Hockey" class="">Hockey</a><ul class=""><li class="first-child "><a href="http://www.thechiller.com/classes/camps-and-clinics" title="Camps and Clinics" class="">Camps and Clinics</a><ul class=""><li class="first-child "><a href="http://www.thechiller.com/classes/camps-and-clinics/adult-drumstick" title="Adult Drumstick Clinic" class="">Adult Drumstick Clinic</a></li><li class=""><a href="http://www.thechiller.com/hockey/blue-jackets-hockey-school" title="Blue Jackets Hockey School" class="">Blue Jackets Hockey School</a></li><li class=""><a href="http://www.thechiller.com/classes/camps-and-clinics/drumstick" title="Drumstick Clinic" class="">Drumstick Clinic</a></li><li class="last-child "><a href="http://www.thechiller.com/classes/camps-and-clinics/tot-drumstick" title="Tot Drumstick Clinic" class="">Tot Drumstick Clinic</a></li></ul></li><li class=""><a href="http://www.thechiller.com/hockey/youth-and-high-school" title="Youth &amp; High School" class="">Youth & High School</a><ul class=""><li class="first-child "><a href="http://www.thechiller.com/pondhockey" title="Chiller Pond Hockey" class="">Chiller Pond Hockey</a></li><li class=""><a href="http://www.thechiller.com/hockey/youth-and-high-school/cshl" title="Summer League" class="">Summer League</a></li><li class="last-child "><a href="http://www.thechiller.com/hockey/tournaments/thanksgivingclassic" title="Thanksgiving Classic" class="">Thanksgiving Classic</a></li></ul></li><li class=""><a href="http://www.thechiller.com/hockey/adult" title="Adult" class="">Adult</a><ul class=""><li class="first-child "><a href="http://www.thechiller.com/hockey/adult/faq" title="FAQ" class="">FAQ</a></li><li class=""><a href="http://www.thechiller.com/media/public/files/hockey/cahl-docs/CAHL_Handbook.pdf" title="CAHL Handbook" class="">CAHL Handbook</a></li><li class=""><a href="http://cahl.aimoo.com/" title="CAHL Forum" class="">CAHL Forum</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/sunday-c2-east" title="Sunday C2 East" class="">Sunday C2 East</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/sunday-c2-west" title="Sunday C2 West" class="">Sunday C2 West</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/sunday-d-east" title="Sunday D East" class="">Sunday D East</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/sunday-d-west" title="Sunday D West" class="">Sunday D West</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/sunday-d-north" title="Sunday D North" class="">Sunday D North</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/sunday-d-south" title="Sunday D South" class="">Sunday D South</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/monday-b" title="Monday B" class="">Monday B</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/monday-e" title="Monday E" class="">Monday E</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/tuesday-c-east" title="Tuesday C East" class="">Tuesday C East</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/tuesday-c-west" title="Tuesday C West" class="">Tuesday C West</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/weds-c-east" title="Weds C East" class="">Weds C East</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/weds-c-west" title="Weds C West" class="">Weds C West</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/thursday-a" title="Thursday A" class="">Thursday A</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/thur-d-east" title="Thur D East" class="">Thur D East</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/thur-d-west" title="Thur D West" class="">Thur D West</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/thur-d-south" title="Thur D South" class="">Thur D South</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/friday-c2" title="Friday C2" class="">Friday C2</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult/firefighters-league" title="Firefighters League" class="">Firefighters League</a></li><li class="last-child "><a href="http://www.thechiller.com/hockey/adult/womens" title="Women&#039;s League" class="">Women's League</a></li></ul></li><li class=""><a href="http://www.thechiller.com/hockey/blue-jackets-hockey-school" title="Blue Jackets Hockey School" class="">Blue Jackets Hockey School</a><ul class=""><li class="first-child "><a href="http://www.thechiller.com/hockey/blue-jackets-hockey-school/instructors" title="2009 CBJHS Instructors" class="">2009 CBJHS Instructors</a></li></ul></li><li class=""><a href="http://www.thechiller.com/hockey/tournaments" title="Tournaments" class="">Tournaments</a><ul class=""><li class="first-child "><a href="http://www.thechiller.com/hockey/tournaments/thanksgivingclassic" title="Thanksgiving Classic" class="">Thanksgiving Classic</a></li></ul></li><li class="last-child "><a href="http://www.thechiller.com/hockey/schedules" title="Schedules" class="">Schedules</a><ul class=""><li class="first-child "><a href="http://www.thechiller.com/hockey/schedules/14-17-drop-in" title="14-17 Drop-In Hockey" class="">14-17 Drop-In Hockey</a></li><li class=""><a href="http://www.thechiller.com/hockey/schedules/adult-drop-in" title="Adult Drop-In Hockey" class="">Adult Drop-In Hockey</a></li><li class=""><a href="http://www.thechiller.com/hockey/schedules/5-12-stick-and-puck" title="5-12 Stick &amp; Puck" class="">5-12 Stick & Puck</a></li><li class=""><a href="http://www.thechiller.com/hockey/schedules/13-17-stick-and-puck" title="13-17 Stick &amp; Puck" class="">13-17 Stick & Puck</a></li><li class=""><a href="http://www.thechiller.com/hockey/schedules/adult-stick-and-puck" title="Adult Stick &amp; Puck" class="">Adult Stick & Puck</a></li><li class=""><a href="http://www.thechiller.com/hockey/schedules/tgif" title="TGIF - 40+ Friday Hockey " class="">TGIF - 40+ Friday Hockey </a></li><li class="last-child "><a href="http://www.thechiller.com/hockey/schedules/saturday-night" title="Saturday Night" class="">Saturday Night</a></li></ul></li></ul></li><li class=""><a href="http://www.thechiller.com/public-skating" title="Public Skating" class="">Public Skating</a><ul class=""><li class="first-child "><a href="http://www.thechiller.com/public-skating/dublin" title="Chiller Dublin" class="">Chiller Dublin</a></li><li class=""><a href="http://www.thechiller.com/public-skating/easton" title="Chiller Easton" class="">Chiller Easton</a></li><li class=""><a href="http://www.thechiller.com/public-skating/north" title="Chiller North" class="">Chiller North</a></li><li class="last-child "><a href="http://www.thechiller.com/public-skating/OhioHealth-ice-haus" title="OhioHealth Ice Haus" class="">OhioHealth Ice Haus</a></li></ul></li><li class=""><a href="http://www.thechiller.com/figure-skating" title="Figure Skating" class="">Figure Skating</a><ul class=""><li class="first-child "><a href="http://www.thechiller.com/figure-skating/synchronized" title="Synchronized" class="">Synchronized</a></li><li class=""><a href="http://www.thechiller.com/figure-skating/competitive-rec" title="Competitive/Rec" class="">Competitive/Rec</a></li><li class=""><a href="http://www.thechiller.com/figure-skating/schedule" title="Freestyle Schedule" class="">Freestyle Schedule</a></li><li class=""><a href="http://www.thechiller.com/figure-skating/instructors" title="Instructors" class="">Instructors</a></li><li class="last-child "><a href="http://www.thechiller.com/figure-skating/events" title="Special Events" class="">Special Events</a></li></ul></li><li class=""><a href="http://www.thechiller.com/classes" title="Classes" class="">Classes</a><ul class=""><li class="first-child "><a href="http://www.thechiller.com/classes/skating" title="Skating" class="">Skating</a></li><li class=""><a href="http://www.thechiller.com/classes/hockey" title="Hockey" class="">Hockey</a></li><li class=""><a href="http://www.thechiller.com/classes/camps-and-clinics" title="Camps and Clinics" class="">Camps and Clinics</a><ul class=""><li class="first-child "><a href="http://www.thechiller.com/classes/camps-and-clinics/adult-drumstick" title="Adult Drumstick Clinic" class="">Adult Drumstick Clinic</a></li><li class=""><a href="http://www.thechiller.com/hockey/blue-jackets-hockey-school" title="Blue Jackets Hockey School" class="">Blue Jackets Hockey School</a></li><li class=""><a href="http://www.thechiller.com/classes/camps-and-clinics/camp-chiller" title="Camp Chiller" class="">Camp Chiller</a></li><li class=""><a href="http://www.thechiller.com/classes/camps-and-clinics/drumstick" title="Drumstick Clinic" class="">Drumstick Clinic</a></li><li class="last-child "><a href="http://www.thechiller.com/classes/camps-and-clinics/tot-drumstick" title="Tot Drumstick Clinic" class="">Tot Drumstick Clinic</a></li></ul></li><li class="last-child "><a href="http://www.thechiller.com/classes/home-school" title="Home&#039;sCOOL" class="">Home'sCOOL</a></li></ul></li><li class=""><a href="http://www.thechiller.com/programs" title="Other Programs" class="">Other Programs</a><ul class=""><li class="first-child "><a href="http://www.thechiller.com/programs/speedskating" title="Speedskating" class="">Speedskating</a></li><li class=""><a href="http://www.thechiller.com/programs/ohio-sled-hockey" title="Sled Hockey" class="">Sled Hockey</a></li><li class=""><a href="http://www.thechiller.com/programs/broomball" title="Broomball" class="">Broomball</a></li><li class="last-child "><a href="http://www.thechiller.com/programs/friday-night-meltdown" title="Friday Night Meltdown" class="">Friday Night Meltdown</a></li></ul></li><li class="last-child current"><a href="http://www.thechiller.com/rink-schedule" title="Daily Rink Schedule" class="current">Daily Rink Schedule</a></li></ul>			</div>	<!-- /nav -->

					</div>	<!-- /header -->

		<div id="content">
			<div id="copy">




	<div id="body">
		<h1>Daily Rink Schedule</h1>

<p><strong>Please note:</strong></p>

<p>The Daily Rink Schedule is available for customers to verify confirmed reservations and/or program schedules.  It is not necessarily a list of ice times available for booking.  For ice time availability please <a href="/contact-us">contact us</a>.</p>

<ul>
<li>Chiller Dublin: 614-764-1000</li>
<li>Chiller Easton: 614-475-7575 </li>
<li>Chiller North: 740-549-0009</li>
<li>OhioHealth Ice Haus 614-246-3380</li>
<li>Chiller Ice Works 614-433-9600</li>
</ul>

<p><a href="http://youtu.be/f2IaTOyDh6o" title="Chiller TV Ad">View the Chiller TV ad on YouTube &gt;</a></p>

		<!--2011-10-19-->
			<style type="text/css" media="screen">
				#date-pickr { margin: 15px 0px; }
				#date-pickr label { color: #002b62; text-transform: uppercase; font-weight: bold; font-size: 12px; padding-right: 10px; }
			</style>

			<form action="" id="date-pickr" method="post">
				<div>
				<label for="date-select">Schedule Date</label>
				<select id="date-month" name="date[month]" >

<option value="01">January</option>
<option value="02">February</option>
<option value="03">March</option>
<option value="04">April</option>
<option value="05">May</option>
<option value="06">June</option>
<option value="07">July</option>
<option value="08">August</option>
<option value="09">September</option>

<option value="10" selected="selected">October</option>
<option value="11">November</option>
<option value="12">December</option>
</select><select id="date-day" name="date[day]" >
<option value="01">01</option>
<option value="02">02</option>
<option value="03">03</option>
<option value="04">04</option>
<option value="05">05</option>

<option value="06">06</option>
<option value="07">07</option>
<option value="08">08</option>
<option value="09">09</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
<option value="13">13</option>
<option value="14">14</option>

<option value="15">15</option>
<option value="16">16</option>
<option value="17">17</option>
<option value="18">18</option>
<option value="19" selected="selected">19</option>
<option value="20">20</option>
<option value="21">21</option>
<option value="22">22</option>
<option value="23">23</option>

<option value="24">24</option>
<option value="25">25</option>
<option value="26">26</option>
<option value="27">27</option>
<option value="28">28</option>
<option value="29">29</option>
<option value="30">30</option>
<option value="31">31</option>
</select>				<!--
				<select id="date-select" name="date">
										<option value="2011-10-19" selected="selected">Wednesday, October 19, 2011</option>
										<option value="2011-10-20" >Thursday, October 20, 2011</option>
										<option value="2011-10-21" >Friday, October 21, 2011</option>
										<option value="2011-10-22" >Saturday, October 22, 2011</option>
										<option value="2011-10-23" >Sunday, October 23, 2011</option>
										<option value="2011-10-24" >Monday, October 24, 2011</option>
										<option value="2011-10-25" >Tuesday, October 25, 2011</option>
										<option value="2011-10-26" >Wednesday, October 26, 2011</option>
										<option value="2011-10-27" >Thursday, October 27, 2011</option>
										<option value="2011-10-28" >Friday, October 28, 2011</option>
										<option value="2011-10-29" >Saturday, October 29, 2011</option>
									</select>
				-->

				<button type="submit">Go</button>
				</div>
			</form>
			<table cellspacing="0" class="schedule"><tr class="title 2012-06-23"><th colspan="4">Chiller Dublin</th></tr><tr class="2011-10-19"><td>Hilliard Club Hockey</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 1">Dublin 1</a></td><td>October 19, 2011</td><td>5:45am &ndash; 6:45am</td></tr><tr class="2011-10-19"><td>Freestyle</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 2">Dublin 2</a></td><td>October 19, 2011</td><td>6:00am &ndash; 9:15am</td></tr><tr class="2011-10-19"><td>Freestyle</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 2">Dublin 2</a></td><td>October 19, 2011</td><td>9:30am &ndash; 11:15am</td></tr><tr class="2011-10-19"><td>Learn to play Hockey</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 1">Dublin 1</a></td><td>October 19, 2011</td><td>9:40am &ndash; 11:10am</td></tr><tr class="2011-10-19"><td>Drop In Hockey, Adult - 18+ ONLY</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 1">Dublin 1</a></td><td>October 19, 2011</td><td>11:30am &ndash; 1:15pm</td></tr><tr class="2011-10-19"><td>Noon Skate</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 2">Dublin 2</a></td><td>October 19, 2011</td><td>11:30am &ndash; 12:45pm</td></tr><tr class="2011-10-19"><td>Freestyle</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 2">Dublin 2</a></td><td>October 19, 2011</td><td>1:00pm &ndash; 3:30pm</td></tr><tr class="2011-10-19"><td>Hockey privates</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 1">Dublin 1</a></td><td>October 19, 2011</td><td>1:30pm &ndash; 2:30pm</td></tr><tr class="2011-10-19"><td>Dublin High School Hockey Association (JEROME)</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 1">Dublin 1</a></td><td>October 19, 2011</td><td>3:30pm &ndash; 4:35pm</td></tr><tr class="2011-10-19"><td>Freestyle</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 2">Dublin 2</a></td><td>October 19, 2011</td><td>3:45pm &ndash; 5:45pm</td></tr><tr class="2011-10-19"><td>Stick and Puck Ages 13-17</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 1">Dublin 1</a></td><td>October 19, 2011</td><td>4:50pm &ndash; 5:50pm</td></tr><tr class="2011-10-19"><td>Learn To Skate</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 2">Dublin 2</a></td><td>October 19, 2011</td><td>6:00pm &ndash; 7:30pm</td></tr><tr class="2011-10-19"><td>Columbus Chill YHA (JACKETS 99 A MJR AND 98 AA)</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 1">Dublin 1</a></td><td>October 19, 2011</td><td>6:00pm &ndash; 7:50pm</td></tr><tr class="2011-10-19"><td>Columbus Chill YHA (B BEARS AND WILDCATS)</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 2">Dublin 2</a></td><td>October 19, 2011</td><td>7:40pm &ndash; 8:40pm</td></tr><tr class="2011-10-19"><td>Ohio AAA Blue Jackets (00s)</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 1">Dublin 1</a></td><td>October 19, 2011</td><td>8:00pm &ndash; 9:30pm</td></tr><tr class="2011-10-19"><td>Columbus Chill YHA (JACKETS 00 AA MNR)</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 2">Dublin 2</a></td><td>October 19, 2011</td><td>8:50pm &ndash; 9:40pm</td></tr><tr class="2011-10-19"><td>Blackhawks vs. Penguins (Weds CWHL)</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 1">Dublin 1</a></td><td>October 19, 2011</td><td>9:40pm &ndash; 10:40pm</td></tr><tr class="2011-10-19"><td>Gallo's Bats vs. Applied Performance (Weds C East)</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 2">Dublin 2</a></td><td>October 19, 2011</td><td>9:50pm &ndash; 10:50pm</td></tr><tr class="2011-10-19"><td>Blue Jackets vs. Red Wings (Weds CWHL)</td><td><a href="http://www.thechiller.com/locations/chiller-dublin/" title="Dublin 1">Dublin 1</a></td><td>October 19, 2011</td><td>10:50pm &ndash; 11:50pm</td></tr></table><table cellspacing="0" class="schedule"><tr class="title 2012-06-23"><th colspan="4">Chiller Easton</th></tr><tr class="2011-10-19"><td>Noon Skate</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 1">Easton 1</a></td><td>October 19, 2011</td><td>11:30am &ndash; 12:45pm</td></tr><tr class="2011-10-19"><td>Freestyle</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 1">Easton 1</a></td><td>October 19, 2011</td><td>1:00pm &ndash; 4:15pm</td></tr><tr class="2011-10-19"><td>Gahanna Hockey (Captain's Practice)</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 2">Easton 2</a></td><td>October 19, 2011</td><td>4:20pm &ndash; 5:20pm</td></tr><tr class="2011-10-19"><td>PHA Prowlers</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 1">Easton 1</a></td><td>October 19, 2011</td><td>4:30pm &ndash; 5:45pm</td></tr><tr class="2011-10-19"><td>Easton Youth Hockey (ADM - MITE BLACKHAWKS, FLYERS AND PENGUINS AND MM BRUINS)</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 2">Easton 2</a></td><td>October 19, 2011</td><td>5:30pm &ndash; 6:20pm</td></tr><tr class="2011-10-19"><td>Learn to play Hockey</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 1">Easton 1</a></td><td>October 19, 2011</td><td>6:00pm &ndash; 7:35pm</td></tr><tr class="2011-10-19"><td>Easton Youth Hockey (ADM - MITE KINGS, BRUINS AND RANGERS, MM PENGUINS)</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 2">Easton 2</a></td><td>October 19, 2011</td><td>6:30pm &ndash; 7:20pm</td></tr><tr class="2011-10-19"><td>Easton Youth Hockey (BANTAM KINGS AND BLACKHAWKS)</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 2">Easton 2</a></td><td>October 19, 2011</td><td>7:30pm &ndash; 8:20pm</td></tr><tr class="2011-10-19"><td>Chiller Speed Skating Club</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 1">Easton 1</a></td><td>October 19, 2011</td><td>7:45pm &ndash; 8:45pm</td></tr><tr class="2011-10-19"><td>Northeast Storm</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 2">Easton 2</a></td><td>October 19, 2011</td><td>8:30pm &ndash; 9:20pm</td></tr><tr class="2011-10-19"><td>Body Art vs. Fire Kings (Weds C West)</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 1">Easton 1</a></td><td>October 19, 2011</td><td>9:00pm &ndash; 10:00pm</td></tr><tr class="2011-10-19"><td>Northeast Storm</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 2">Easton 2</a></td><td>October 19, 2011</td><td>9:30pm &ndash; 10:20pm</td></tr><tr class="2011-10-19"><td>Black and Tan vs. Blades of Steel (Weds C East)</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 1">Easton 1</a></td><td>October 19, 2011</td><td>10:15pm &ndash; 11:15pm</td></tr><tr class="2011-10-19"><td>BT4 Jimmy V's vs. Benjamin Steel (Weds C West)</td><td><a href="http://www.thechiller.com/locations/chiller-easton/" title="Easton 2">Easton 2</a></td><td>October 19, 2011</td><td>10:30pm &ndash; 11:30pm</td></tr></table><table cellspacing="0" class="schedule"><tr class="title 2012-03-25"><th colspan="4">Chiller Ice Works</th></tr><tr class="2011-10-19"><td>Westerville Warcats</td><td><a href="http://www.thechiller.com/locations/ice-works/" title="Chiller Ice Works">Chiller Ice Works</a></td><td>October 19, 2011</td><td>4:50pm &ndash; 5:50pm</td></tr><tr class="2011-10-19"><td>Columbus Chill YHA (JACKETS 02 A MNR)</td><td><a href="http://www.thechiller.com/locations/ice-works/" title="Chiller Ice Works">Chiller Ice Works</a></td><td>October 19, 2011</td><td>6:00pm &ndash; 6:50pm</td></tr><tr class="2011-10-19"><td>Columbus Chill YHA (JACKETS 00 A MNR)</td><td><a href="http://www.thechiller.com/locations/ice-works/" title="Chiller Ice Works">Chiller Ice Works</a></td><td>October 19, 2011</td><td>7:00pm &ndash; 7:50pm</td></tr><tr class="2011-10-19"><td>Ohio AAA Blue Jackets (97s)</td><td><a href="http://www.thechiller.com/locations/ice-works/" title="Chiller Ice Works">Chiller Ice Works</a></td><td>October 19, 2011</td><td>8:00pm &ndash; 9:30pm</td></tr><tr class="2011-10-19"><td>Capital Amateur Hockey (Practice - 98A-Schnabel)</td><td><a href="http://www.thechiller.com/locations/ice-works/" title="Chiller Ice Works">Chiller Ice Works</a></td><td>October 19, 2011</td><td>9:40pm &ndash; 10:40pm</td></tr></table><table cellspacing="0" class="schedule"><tr class="title 2012-06-23"><th colspan="4">Chiller North</th></tr><tr class="2011-10-19"><td>privates</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 2">North 2</a></td><td>October 19, 2011</td><td>10:00am &ndash; 10:30am</td></tr><tr class="2011-10-19"><td>private rental</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 2">North 2</a></td><td>October 19, 2011</td><td>10:30am &ndash; 11:30am</td></tr><tr class="2011-10-19"><td>Noon Skate</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 2">North 2</a></td><td>October 19, 2011</td><td>11:30am &ndash; 12:45pm</td></tr><tr class="2011-10-19"><td>Freestyle</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 2">North 2</a></td><td>October 19, 2011</td><td>1:00pm &ndash; 3:00pm</td></tr><tr class="2011-10-19"><td>Olentangy High School Hockey</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 2">North 2</a></td><td>October 19, 2011</td><td>3:30pm &ndash; 4:30pm</td></tr><tr class="2011-10-19"><td>Liberty High School Hockey</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 1">North 1</a></td><td>October 19, 2011</td><td>3:40pm &ndash; 4:40pm</td></tr><tr class="2011-10-19"><td>Freestyle</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 2">North 2</a></td><td>October 19, 2011</td><td>4:40pm &ndash; 5:40pm</td></tr><tr class="2011-10-19"><td>Thomas Worthington HS Hockey (Captains Practice)</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 1">North 1</a></td><td>October 19, 2011</td><td>4:50pm &ndash; 5:50pm</td></tr><tr class="2011-10-19"><td>Learn To Skate</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 2">North 2</a></td><td>October 19, 2011</td><td>6:00pm &ndash; 7:30pm</td></tr><tr class="2011-10-19"><td>Capital Amateur Hockey (Practice - SQ02A-Tomechak)</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 1">North 1</a></td><td>October 19, 2011</td><td>6:00pm &ndash; 6:50pm</td></tr><tr class="2011-10-19"><td>Capital Amateur Hockey (Practice - PW3)</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 1">North 1</a></td><td>October 19, 2011</td><td>7:00pm &ndash; 7:50pm</td></tr><tr class="2011-10-19"><td>Capital Amateur Hockey (Practice - PW4 / PW5)</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 2">North 2</a></td><td>October 19, 2011</td><td>7:40pm &ndash; 8:30pm</td></tr><tr class="2011-10-19"><td>Columbus Chill YHA (SQ BRUINS AND JACKETS 99 AA MJR)</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 1">North 1</a></td><td>October 19, 2011</td><td>8:00pm &ndash; 8:50pm</td></tr><tr class="2011-10-19"><td>Capital Amateur Hockey (Practice - Ban3 / Ban4)</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 2">North 2</a></td><td>October 19, 2011</td><td>8:40pm &ndash; 9:30pm</td></tr><tr class="2011-10-19"><td>Columbus Chill YHA (JACKETS 99 AA MJR)</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 1">North 1</a></td><td>October 19, 2011</td><td>9:00pm &ndash; 9:50pm</td></tr><tr class="2011-10-19"><td>Your AD Here vs. Winking Lizard (Weds C East)</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 2">North 2</a></td><td>October 19, 2011</td><td>9:40pm &ndash; 10:40pm</td></tr><tr class="2011-10-19"><td>Buffalo Wings and Rings vs. Eagles (Weds C East)</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 1">North 1</a></td><td>October 19, 2011</td><td>10:00pm &ndash; 11:00pm</td></tr><tr class="2011-10-19"><td>DeWalt Tools vs. Happy Gilmore (Weds C West)</td><td><a href="http://www.thechiller.com/locations/chiller-north/" title="North 2">North 2</a></td><td>October 19, 2011</td><td>10:50pm &ndash; 11:50pm</td></tr></table><table cellspacing="0" class="schedule"><tr class="title 2012-06-22"><th colspan="4">OhioHealth Ice Haus</th></tr><tr class="2011-10-19"><td>Drop In Hockey, Adult - 18+ ONLY</td><td><a href="http://www.thechiller.com/locations/ohiohealth-ice-haus/" title="OhioHealth Ice Haus">OhioHealth Ice Haus</a></td><td>October 19, 2011</td><td>6:00am &ndash; 8:00am</td></tr><tr class="2011-10-19"><td>Blue Jackets</td><td><a href="http://www.thechiller.com/locations/ohiohealth-ice-haus/" title="OhioHealth Ice Haus">OhioHealth Ice Haus</a></td><td>October 19, 2011</td><td>9:30am &ndash; 1:00pm</td></tr><tr class="2011-10-19"><td>Blue Jackets</td><td><a href="http://www.thechiller.com/locations/ohiohealth-ice-haus/" title="OhioHealth Ice Haus">OhioHealth Ice Haus</a></td><td>October 19, 2011</td><td>1:10pm &ndash; 3:10pm</td></tr><tr class="2011-10-19"><td>Ohio AAA Blue Jackets (U18)</td><td><a href="http://www.thechiller.com/locations/ohiohealth-ice-haus/" title="OhioHealth Ice Haus">OhioHealth Ice Haus</a></td><td>October 19, 2011</td><td>6:10pm &ndash; 7:10pm</td></tr><tr class="2011-10-19"><td>Capital Amateur Hockey (Practice - SQ01A-Bowen)</td><td><a href="http://www.thechiller.com/locations/ohiohealth-ice-haus/" title="OhioHealth Ice Haus">OhioHealth Ice Haus</a></td><td>October 19, 2011</td><td>7:20pm &ndash; 8:20pm</td></tr><tr class="2011-10-19"><td>Capital Amateur Hockey (Practice - PW00AA-Baker)</td><td><a href="http://www.thechiller.com/locations/ohiohealth-ice-haus/" title="OhioHealth Ice Haus">OhioHealth Ice Haus</a></td><td>October 19, 2011</td><td>8:30pm &ndash; 9:30pm</td></tr><tr class="2011-10-19"><td>New Originals vs. Lady Chatterly's (Weds C West)</td><td><a href="http://www.thechiller.com/locations/ohiohealth-ice-haus/" title="OhioHealth Ice Haus">OhioHealth Ice Haus</a></td><td>October 19, 2011</td><td>9:40pm &ndash; 10:40pm</td></tr></table>
		<p></p>

	</div>	<!-- /body -->
			</div>	<!-- /copy -->

			<div id="sidebar">

				<div id="twitter">
					<h3>Chiller Tweets</h3>

					<ul class="tweets"><li>RT <a href="http://twitter.com/buccigross">@buccigross</a>: Ohio sheriff says mountain lion, grizzly bear and monkey only remaining animals loose.<br><small>Posted on Wednesday at 11:08am (<a href="http://twitter.com/home?status=@ChillerIceRinks">@</a>,&nbsp;<a href="http://twitter.com/home?status=RT+%40ChillerIceRinks+RT+%40buccigross%3A+Ohio+sheriff+says+mountain+lion%2C+grizzly+bear+and+monkey+only+remaining+animals+loose.">RT</a>)</small></li><li>RT <a href="http://twitter.com/cosicols">@cosicols</a>: Check out Spooky Science next weekend at <a href="http://twitter.com/COSICols">@COSICols</a>!  Oct. 28-29.  Visit <a href="http://t.co/HAhdJhnZ">http://t.co/HAhdJhnZ</a> for times.<br><small>Posted on Wednesday at 11:07am (<a href="http://twitter.com/home?status=@ChillerIceRinks">@</a>,&nbsp;<a href="http://twitter.com/home?status=RT+%40ChillerIceRinks+RT+%40cosicols%3A+Check+out+Spooky+Science+next+weekend+at+%40COSICols%21++Oct.+28-29.++Visit+http%3A%2F%2Ft.co%2FHAhdJhnZ+for+times.">RT</a>)</small></li></ul>

					<h4>Connect With Us</h4>
					<ul class="connect">
						<li><a href="http://twitter.com/ChillerIceRinks" title="Twitter"><img src="http://www.thechiller.com/media/images/icons/twitter.png" alt="Twitter"></a></li>
						<li><a href="http://www.facebook.com/chillericerinks" title="Facebook"><img src="http://www.thechiller.com/media/images/icons/facebook.png" alt="Facebook"></a></li>
						<li><a href="http://www.flickr.com/photos/46286209@N07/" title="Flickr"><img src="http://www.thechiller.com/media/images/icons/flickr.png" alt="Flickr"></a></li>
						<li><a href="http://www.thechiller.com/news/feed" titlte="Blog Feed"><img src="http://www.thechiller.com/media/images/icons/rss.png" alt="RSS"></a></li>
						<li><a href="http://www.youtube.com/user/ChillerIceRinks" titlte="YouTube"><img src="http://www.thechiller.com/media/images/icons/youtube.png" alt="YouTube"></a></li>
					</ul>


					<script type="text/javascript" src="http://static.ak.connect.facebook.com/connect.php/en_US"></script>
					<script type="text/javascript">FB.init("e109363ebf1b76468808972298a3407e");</script>
					<div id="fanbox">
						<script type="text/javascript" charset="utf-8">document.write('<fb:fan profile_id="67369588424" stream="0" connections="0" logobar="0" width="260" height="100"></fb:fan>');</script>
					</div>

				</div>	<!-- /twitter -->

								<div id="news">

					<h3>Chiller News</h3>
					<p><strong>Crossover Sports Makes Strides Into Columbus Hockey and Skating!</strong><br>We're excited to announce the opening of our new retail partner Crossover Sports - now OPEN at Chiller North. <a href="http://www.thechiller.com/blog/2011-10-14/crossover-sports-makes-strides-into-columbus-hockey-and-skating" title="Read more">Read more &#x2192;</a></p><hr><p><strong>Have a Ghoulishly Good Time at Fright Night Meltdown</strong><br>Don't miss this year's Halloween Fright Night Meltdown, featuring free candy, live DJ, costume contest and more! <a href="http://www.thechiller.com/blog/2011-10-10/have-a-ghoulishly-good-time-at-fright-night-meltdown" title="Read more">Read more &#x2192;</a></p>				</div>	<!-- /news -->


				<div class="advertisement"></div>	<!-- /advertisement -->
			</div>	<!-- /sidebar -->

			<div id="columns">
				<table class="list" id="calendar">
					<tr>
						<th>Upcoming Events <span>(<a href="http://www.thechiller.com/events/" title="See all events">See all</a>)</span></th>
					</tr>

					<tr>

								<td class="first-child">
								<div class="calendar-icon">Oct<span>28</span></div>
									<a href="http://www.thechiller.com/events/2011/10/28/fright-night-meltdown/" title="Fright Night Meltdown">Fright Night Meltdown</a><br>
									Join your best fiends as the boys and ghouls take the ice for this year's Fright
								</td>
							</tr><tr>
								<td>
								<div class="calendar-icon">Nov<span>20</span></div>

									<a href="http://www.thechiller.com/events/2011/11/20/chiller-2011-holiday-show/" title="Chiller 2011 Holiday Show">Chiller 2011 Holiday Show</a><br>
									The Chiller Holiday Ice Show is a wonderful opportunity for friends and family t
								</td>
							</tr>				</table>

								<table class="list" id="blog">
					<tr>
						<th>Chiller Blog<span>(<a href="http://www.thechiller.com/blog/" title="See all blog posts">See all</a>)</span></th>

					</tr>
					<tr><td class="first-child"><strong><a href="http://www.thechiller.com/blog/2011-10-14/crossover-sports-makes-strides-into-columbus-hockey-and-skating" title="Crossover Sports Makes Strides Into Columbus Hockey and Skating!">Crossover Sports Makes Strides Into Columbus Hockey and Skating!</a></strong><br>We're excited to announce the opening of our new retail partner Crossover Sports - now OPEN at Chiller North.</td></tr><tr><td><strong><a href="http://www.thechiller.com/blog/2011-10-10/have-a-ghoulishly-good-time-at-fright-night-meltdown" title="Have a Ghoulishly Good Time at Fright Night Meltdown">Have a Ghoulishly Good Time at Fright Night Meltdown</a></strong><br>Don't miss this year's Halloween Fright Night Meltdown, featuring free candy, live DJ, costume contest and more!</td></tr>				</table>

				<table class="list" id="schedules">
					<tr><th>Hockey Schedules <span>(<a href="http://www.thechiller.com/hockey/schedules">See all</a>)</span></th></tr>

					<tr><td class="first-child"><a href="http://www.thechiller.com/hockey/schedules/14-17-drop-in">14-17 Drop-In Hockey</a></td></tr>
					<tr><td><a href="http://www.thechiller.com/hockey/schedules/adult-drop-in">Adult Drop-In Hockey</a></td></tr>
					<tr><td><a href="http://www.thechiller.com/hockey/schedules/adult-stick-and-puck">Adult Stick &amp; Puck</a></td></tr>
					<tr><td><a href="http://www.thechiller.com/hockey/schedules/13-17-stick-and-puck">13-17 Stick &amp; Puck</a></td></tr>
					<tr><td><a href="http://www.thechiller.com/hockey/schedules/5-12-stick-and-puck">5-12 Stick &amp; Puck</a></td></tr>

					<tr><td><a href="http://www.thechiller.com/hockey/schedules/tgif">TGIF - 40+ Friday Hockey</a></td></tr>
					<tr><td><a href="http://www.thechiller.com/hockey/schedules/saturday-night">Saturday Night Hockey</a></td></tr>
				</table>
			</div>	<!-- /columns -->

		</div>	<!-- /content -->

		<div class="advertisement" id="banner"><a href="http://cafepress.com/chillericerinks" title="Chiller Online Store"><img src="/media/public/images/advertisements/StoreBanner2.gif" alt="Chiller Online Store"></a></div>	<!-- /advertisement -->
	</div>	<!-- /container -->


	<div id="footer">
		<div class="container">
			<div id="footer-nav">
				<h4>Explore the Chiller</h4>

				<div class="column">
					<h5><a href="http://www.thechiller.com/hockey/" title="Hockey">Hockey</a></h5>
					<ul class=""><li class="first-child "><a href="http://www.thechiller.com/classes/camps-and-clinics" title="Camps and Clinics" class="">Camps and Clinics</a></li><li class=""><a href="http://www.thechiller.com/hockey/youth-and-high-school" title="Youth &amp; High School" class="">Youth & High School</a></li><li class=""><a href="http://www.thechiller.com/hockey/adult" title="Adult" class="">Adult</a></li><li class=""><a href="http://www.thechiller.com/hockey/blue-jackets-hockey-school" title="Blue Jackets Hockey School" class="">Blue Jackets Hockey School</a></li><li class=""><a href="http://www.thechiller.com/hockey/tournaments" title="Tournaments" class="">Tournaments</a></li><li class="last-child "><a href="http://www.thechiller.com/hockey/schedules" title="Schedules" class="">Schedules</a></li></ul>				</div>	<!-- /column -->

				<div class="column">
					<h5><a href="http://www.thechiller.com/public-skating/" title="Public Skating">Public Skating</a></h5>
					<ul class=""><li class="first-child "><a href="http://www.thechiller.com/public-skating/dublin" title="Chiller Dublin" class="">Chiller Dublin</a></li><li class=""><a href="http://www.thechiller.com/public-skating/easton" title="Chiller Easton" class="">Chiller Easton</a></li><li class=""><a href="http://www.thechiller.com/public-skating/north" title="Chiller North" class="">Chiller North</a></li><li class="last-child "><a href="http://www.thechiller.com/public-skating/OhioHealth-ice-haus" title="OhioHealth Ice Haus" class="">OhioHealth Ice Haus</a></li></ul>				</div>	<!-- /column -->

				<div class="column">

					<h5><a href="http://www.thechiller.com/figure-skating/" title="Figure Skating">Figure Skating</a></h5>
					<ul class=""><li class="first-child "><a href="http://www.thechiller.com/figure-skating/synchronized" title="Synchronized" class="">Synchronized</a></li><li class=""><a href="http://www.thechiller.com/figure-skating/competitive-rec" title="Competitive/Rec" class="">Competitive/Rec</a></li><li class=""><a href="http://www.thechiller.com/figure-skating/schedule" title="Freestyle Schedule" class="">Freestyle Schedule</a></li><li class=""><a href="http://www.thechiller.com/figure-skating/instructors" title="Instructors" class="">Instructors</a></li><li class="last-child "><a href="http://www.thechiller.com/figure-skating/events" title="Special Events" class="">Special Events</a></li></ul>				</div>	<!-- /column -->

				<div class="column">
					<h5><a href="http://www.thechiller.com/classes/" title="Group Classes">Group Classes</a></h5>

					<ul class=""><li class="first-child "><a href="http://www.thechiller.com/classes/skating" title="Skating" class="">Skating</a></li><li class=""><a href="http://www.thechiller.com/classes/hockey" title="Hockey" class="">Hockey</a></li><li class=""><a href="http://www.thechiller.com/classes/camps-and-clinics" title="Camps and Clinics" class="">Camps and Clinics</a></li><li class="last-child "><a href="http://www.thechiller.com/classes/home-school" title="Home&#039;sCOOL" class="">Home'sCOOL</a></li></ul>				</div>	<!-- /column -->

				<div class="column">
					<h5><a href="http://www.thechiller.com/rink-schedule/" title="Daily Rink Schedule">Daily Rink Schedule</a></h5>
				</div>	<!-- /column -->

			</div>	<!-- /footer-nav -->

			<div id="etc">
				<ul class="footer"><li class="first-child "><a href="http://www.thechiller.com/sitemap" title="Sitemap" class="">Sitemap</a></li><li class=""><a href="http://www.thechiller.com/advertise" title="Advertise With Us" class="">Advertise With Us</a></li><li class="last-child "><a href="http://www.thechiller.com/staff" title="Staff Login" class="">Staff Login</a></li></ul>
				<p>&copy;2011 The Chiller. All Rights Reserved.</p>
			</div>
		</div>	<!-- /container -->

	</div>	<!-- /footer -->
	<script type="text/javascript">var _gaq = _gaq || []; _gaq.push(['_setAccount', 'UA-22978957-1']); _gaq.push(['_setDomainName', '.thechiller.com']); _gaq.push(['_trackPageview']); (function() { var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true; ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s); })();</script></body>
</html>
    }

  end
end

