-------------------------------------------
-- What are tracks for a given album?
--------------------------------------------
select
  album.name as album,
  song.name as song
from
  album
inner join track
  on album.id = track.album_id
inner join song
  on song.id = track.song_id
where
  album.name = 'This is Acting';

-------------------------------------------
-- What instruments does each artist play?
--------------------------------------------
select
  artist.id, artist.name as artist,
  instrument.name as instrument
from
  artist
inner join plays
  on artist.id = plays.artist_id
inner join instrument
  on instrument.id = plays.instrument_id
group by
  artist.id,
  artist.name,
  instrument.name
order by
  artist.id;

-- What is the track with the longest duration?
select
  song.name as song,
  track.duration as duration
from
  song
inner join track
  on song.id = track.song_id
group by
  song.name,
  duration
order by
  duration
desc limit 1;

-- What are the albums released between 2010 - 2020?
select
  album.name as album,
  year
from
  album
where
  year between 2010 and 2020
order by year asc;
-------------------------------------------------------------------
-- How many albums did a given artist produce between 2010 - 2020?
-------------------------------------------------------------------
select
  artist.name,
  count(album.id) as album_count
from
  artist
inner join album
  on artist.id = album.lead_artist_id and
  artist.name = 'Sia' and
  year between 2010 and 2020
group by
  artist.id;
-------------------------------------------------------------------
-- What is the total run time of each album (based on the duration of its tracks)?
-------------------------------------------------------------------
select
  album.name as album,
  sum(track.duration) as duration
from
  album
inner join track
  on album.id = track.album_id
group by
  album.name;
-------------------------------------------------------------------
-- What are all the tracks a given artist has recorded?
-------------------------------------------------------------------
select
  artist.name as artist,
  song.name as song
from
  artist
inner join album
  on artist.id = album.lead_artist_id
inner join track
  on track.album_id = album.id
inner join song
  on song.id = track.song_id and
  artist.name = 'Sia';
----------------------------------------------------------------------
-- What are the albums recorded by only one solo artist?
-----------------------------------------------------------------------
select
  album.name as album
from
  album
where
  has_collab = FALSE;
----------------------------------------------------------------------
-- What are the albums produced by a given artist as the lead artist?
-----------------------------------------------------------------------
select
  album.name,
  artist.name
from
  album
inner join artist
  on album.lead_artist_id = artist.id
where
  artist.name = 'Sia'
  and has_collab = FALSE;
------------------------------------------------------------------------------------------------
-- What albums has a given artist participated in (not necessarily as lead artist).
-------------------------------------------------------------------------------------------------
select
  album.name,
  artist.name
from
  album
inner join participation
  on album.id = participation.album_id
inner join artist
  on artist.id = participation.lead_artist_id or
  artist.id = participation.collab_id
where
  artist.name = 'Sia'
group by
  album.name,
  artist.name;
------------------------------------------------------------------------------------------------
-- Who are the 5 most prolific artists based on the number of albums they have participated in.
-------------------------------------------------------------------------------------------------
select
  artist.name,
  count(participation.id)
from
  artist
inner join participation
  on artist.id = participation.collab_id
group by
  artist.name;
----------------------------------------------------------------------------------------------
-- What are the albums where the lead artist is a pianist (or any instrument of your choice)?
-----------------------------------------------------------------------------------------------
select
  album.name as album,
  artist.name as artist,
  instrument.name as instrument
from
  album
inner join artist
  on album.lead_artist_id = artist.id
inner join plays
  on plays.artist_id = artist.id
inner join instrument
  on instrument.id = plays.instrument_id and
  instrument.name = 'piano'
group by
  album.name,
  artist.name,
  instrument.name;
----------------------------------------------------
-- What are the top 5 most often recorded songs?
----------------------------------------------------
select
  song.name,
  count(song.id) as song_count
from
  song
inner join track
  on song.id = track.song_id
group by
  song.name
order by
  song_count desc limit 5;
----------------------------------------------------------------------------------------------
-- Who are the top 5 song writers whose songs have been most often recorded?
-----------------------------------------------------------------------------------------------
select
  songwriter.name as songwriter,
  count(wrote.song_id)
from
  songwriter
inner join wrote
  on songwriter.id = wrote.songwriter_id
group by
  songwriter.name;
--------------------------------------------------------------------------------------
-- Who is the most prolific song writer based on the number of songs he has written?
--------------------------------------------------------------------------------------
select
  songwriter.name as songwriter,
  count(wrote.song_id)
from
  songwriter
inner join wrote
  on songwriter.id = wrote.songwriter_id
group by
  songwriter.name limit 1;

-- What artist plays the most instruments?
select
  artist.name as artist,
  count(plays.instrument_id) as instrument_count
from
  artist
inner join plays
  on artist.id = plays.artist_id
group by
  artist
order by
  instrument_count desc limit 1;

-- Who are a given artist's collaborators?
select
  artist.name as artist
from
  artist
inner join participation
  on artist.id = participation.collab_id
where
  participation.lead_artist_id = 1;

-- What artist has had the most collaborators?
select
  participation.lead_artist_id, artist.name as artist,
  count(participation.collab_id) as collab_count
from
  participation
inner join artist
  on participation.lead_artist_id = artist.id
group by
  participation.lead_artist_id,
  artist.name;
