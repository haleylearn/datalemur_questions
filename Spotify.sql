/*
QUESTION 5: Spotify

Title : Top 5 Artists

Task :

Assume there are three Spotify tables: artists, songs, and global_song_rank, which contain information about the artists, songs, and music charts, respectively.

Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. Display the top 5 artist names in ascending order, along with their song appearance ranking.

Assumptions:

If two or more artists have the same number of song appearances, they should be assigned the same ranking, and the rank numbers should be continuous (i.e. 1, 2, 2, 3, 4, 5).
For instance, if both Ed Sheeran and Bad Bunny appear in the Top 10 five times, they should both be ranked 1st and the next artist should be ranked 2nd.

Example Input:
Artists
| artist_id | artist_name |
|-----------|-------------|
| 101       | Ed Sheeran  |
| 120       | Drake       |

Songs
| song_id | artist_id |
|---------|-----------|
| 45202   | 101       |
| 19960   | 120       |

Global_song_rank
| day | song_id | rank |
|-----|---------|------|
| 1   | 45202   | 5    |
| 3   | 45202   | 2    |
| 1   | 19960   | 3    |
| 9   | 19960   | 15   |


Expected Output:

| artist_name | artist_rank |
|-------------|-------------|
| Ed Sheeran  | 1           |
| Drake       | 2           |


*/

---------- SOLUTION 1: Using Window Function DENSE_RANK() ----------

with artist_top10 as ( 
  select 
    a.artist_name,
    count(a.artist_name) as appearance 
  from 
    global_song_rank as gsr 
    left join songs as s 
    on gsr.song_id = s.song_id
    left join artists as a  
    on s.artist_id = a.artist_id 
  where 
    gsr.rank <= 10
  group by a.artist_name
),

artist_ranking as ( 
  select 
    artist_name,
    appearance,
    dense_rank() over(order by appearance desc) as artist_rank
  from 
    artist_top10 
)

select 
  artist_name,
  artist_rank
from 
  artist_ranking 
where 
  artist_rank <= 5;
