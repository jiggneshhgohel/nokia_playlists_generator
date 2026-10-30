The analysis was started with a `listinfo.data` containing 3 user-created playlists on phone.
Then one more was created making it 4 user-created playlists. But since the ending bytes decode
was not successful we resorted to following approach as is noted at the end in
"Analysis/For_Playlists_Index_File/04_user_created_playlists_four/analysis.txt" file:

We remove all user-created playlists and then create one and analyse.
The create one making it two user-created playlists and analyse.
For three and four playlists we already have done the analysis.


##### Update on Oct 27, 2026

After analysing the hex-dump of user_created 35 playlists the plan was to analyse more entries in `listinfo.data`.

So on the phone 36th playlist was created and the updated `listinfo.data` was copied from the phone. That was then placed under
`36_user_created_playlists_36` folder. This way copied `listinfo.data` for 40 playlists created. Checking the `listinfo.data`
after creation of 40th playlist it was found that the 5th and 13th byte patterns (see `decoding_ending_bytes.txt`) remained same.
So thought that instead of creating more playlists one by one and then each time copying `listinfo.data`, let our
`playlists_index_generator` utility generate a `listinfo.data` containing more than 40 entries and then copy it to the phone's
`System\Mp3_res` folder and see whether phone reads it correctly. Tried it and it worked! Then made the utility generate a `listinfo.data`
containing 60 entries and that too was read by the phone. Then finally generated file containing 100 entries and that too worked!




