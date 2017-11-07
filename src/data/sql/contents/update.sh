#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5

# CoOp productline:
#                   2796535 => iPhone
#                   25636 => AT&T
#                   25569 => T-Mobile
#                   2766911 => Verizon
#                   27166 => Sprint
#                   2940614 => Galaxy
#                   2837591 => Galaxy S7
#                   2796095 => Galaxy S7 Edge
#                   2893760 => Moto Z Droid
#                   2993229 => Pixel
#                   1922000001 => LG Stylo 2
#                   26088 => The Home Depot
#                   2782782 => Lowe's
#                   2596000001 => Microsoft Word

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
UPDATE $tbl SET coop_product_id = 2796535 # iPhone
WHERE content_id IN (2966913, 3166710, 3204734, 3195977, 3212040, 3212403, 3212528, 3212375, 3214442,
					 3212466, 3214318, 3213559, 3197067, 3214799, 3216541, 3217189, 3217237, 3217630,
					 2990288, 3202147, 3198354, 3196111, 3197474, 3220610, 3221570, 3221569, 3226754,
					 3227705, 3223323, 3227468, 3225984, 3233704, 3240286, 3231408, 3240217, 3241032,
					 3241024, 3240681, 3241498, 3240459, 3213317, 3214110, 2404256, 2413290, 2407921,
					 2533527, 3242257, 3192745, 32872, 2397119, 2404089, 2403312, 2405227, 2401992,
					 2920135, 2407846, 3194410, 2974206, 3196769, 3134893, 2407504, 2407950, 3215052,
					 2491263, 3246252);

UPDATE $tbl SET coop_product_id = 2816975 # Apple Music
WHERE content_id IN (2817984);

UPDATE $tbl SET coop_product_id = 25636 # AT&T
WHERE content_id IN (3213376, 3213394, 3213397, 3206959, 3201989, 3213292, 3214439, 3197270, 3197665,
					 3199004, 3239538, 2397649, 3198796, 3202756, 3203229, 3105719, 3196012, 2973676,
					 3122897, 2401175, 2407931, 3245003, 3243038);

UPDATE $tbl SET coop_product_id = 25569 # T-Mobile
WHERE content_id IN (3191967, 3213361, 3195905, 3105410, 3195991, 3127876, 3136198, 3136920);

UPDATE $tbl SET coop_product_id = 2766911 # Verizon
WHERE content_id IN (3204057, 3205442, 3212522, 3212907, 3213159, 3213454, 3197255, 3218764, 3197409,
					 3214851, 3215468, 3216114, 3216395, 3216686, 3217173, 3217263, 3217907, 3218679,
					 3213393, 3198173, 3220611, 3221757, 2966547, 3219224, 3220577, 3193777, 3222515,
					 3225753, 3226956, 3229284, 3239639, 3243189, 2397552, 2398614, 2398292, 3202201,
					 3203747, 3196019, 3197534, 3202415, 2929485, 2920904, 2534746, 3218192, 2823804,
					 3245309);

UPDATE $tbl SET coop_product_id = 27166 # Sprint
WHERE content_id IN (3213307, 3213547, 3239283, 3241049, 2401876, 2648491, 3038671, 3139602, 3196947,
					 3202623, 2533194, 2402237, 2401043, 3240111, 3241491);

UPDATE $tbl SET coop_product_id = 2767068 # Samsung
WHERE content_id IN (2461826, 2823689, 3194409, 3198274);

UPDATE $tbl SET coop_product_id = 2940614 # Galaxy
WHERE content_id IN (3205093, 3205513, 3206579, 3207035, 3208448, 3228035, 3229020, 3229953, 3229486,
					 2402807, 3240065, 2398951, 2535028, 2413058, 2402924, 2404691, 2817690, 2412971,
					 2397973, 3233721, 3240921, 3241060, 3205296, 3205618, 2534756, 3245717);
# 2534756 should be Galaxy Note5

UPDATE $tbl SET coop_product_id = 2774671 # SAMSUNG - GALAXY S6
WHERE content_id IN (2788581, 2920708, 2621925, 2533852, 2919998, 2401343, 2399705, 2533562, 2535031,
					 2402401, 2863563, 2841567);
# 2402401 should be Galaxy S6 active

UPDATE $tbl SET coop_product_id = 2837591 # Galaxy S7
WHERE content_id IN (3007580, 3222656, 3221091, 2999429, 3193766, 3221434, 3222713, 3223455, 3230544,
					 3198182, 3090998, 2974011, 2936485, 2967020, 2936387);
# 3222793 is Verizon ad for Galaxy S7, Pixel, Moto Z Droid

UPDATE $tbl SET coop_product_id = 3199135 # Samsung Galaxy S8
WHERE content_id IN (3237994, 3238003, 3238009, 3235937, 3238032, 3238111, 3238715, 3238733, 3238814,
					 3238893, 3240285, 3240289, 3240276, 3240268, 3240353, 3240401, 3240344, 3240345,
					 3238170, 3240889, 3240728, 3241029, 3240041, 3241762, 3240325, 3241089, 3243422,
					 3244298, 3245386, 3245816, 3245783);

UPDATE $tbl SET coop_product_id = 2826658 # SAMSUNG - GALAXY S6 EDGE PHONES
WHERE content_id = 2400336;

UPDATE $tbl SET coop_product_id = 2796095 # Galaxy S7 Edge
WHERE content_id IN (2936015, 3038592, 3097423, 3193586, 2936975, 3207967, 3222798, 3228077, 2936802,
					 2963992);

UPDATE $tbl SET coop_product_id = 2940614 WHERE content_id IN (3205444, 3207194); # Galaxy S7 and Galaxy S7 Edge

UPDATE $tbl SET coop_product_id = 2940614 WHERE content_id IN (3197660, 3197872); # Galaxy Tab E and Gear VR

UPDATE $tbl SET coop_product_id = 2940614 # Galaxy On5
WHERE content_id IN (3202146, 3202442, 3202504, 3202616, 3205131, 3205446, 3205999, 3207204, 3207765,
					 3213903, 3214054, 3205426, 3205427, 3221722, 3220145, 3220149, 3206431, 3207055,
					 3206531, 3202608, 3202886, 3201378);

UPDATE $tbl SET coop_product_id = 3162935 # Samsung Galaxy AMP 2
WHERE content_id IN (3230188, 3219171, 3197188, 3194876, 3195969, 3243927);

UPDATE $tbl SET coop_product_id = 3230506 # Samsung Galaxy J3 Prime
WHERE content_id IN (3240452, 3239557, 3239100, 3239139);

UPDATE $tbl SET coop_product_id = 3162075 # Samsung Galaxy J7
WHERE content_id IN (3233169, 3230949, 3232795);

UPDATE $tbl SET coop_product_id = 2908029 # Samsung Galaxy Note7
WHERE content_id = 3207066;

UPDATE $tbl SET coop_product_id = 2874211 # Samsung Chromebook
WHERE content_id IN (3201713, 3201280);

UPDATE $tbl SET coop_product_id = 2817996 # Samsung Family Hub
WHERE content_id = 3195651;

UPDATE $tbl SET coop_product_id = 3136265 # Motorola Droid
WHERE content_id = 2534774;
# 2534774 should be mapped Motorola Droid Turbo

UPDATE $tbl SET coop_product_id = 2893760 # Moto Z Droid
WHERE content_id IN (3219094, 3220951, 3227476);

UPDATE $tbl SET coop_product_id = 2993229 # Pixel
WHERE content_id IN (3219144, 3221804);

UPDATE $tbl SET coop_product_id = 2765234 # LG
WHERE content_id IN (2400723, 2490709);
# 2400723 should be mapped LG G4

UPDATE $tbl SET coop_product_id = 1922000001 # LG Stylo 2
WHERE content_id IN (3213634);

UPDATE $tbl SET coop_product_id = 3163464 # LG Spree
WHERE content_id IN (3203030);

UPDATE $tbl SET coop_product_id = 3276162 # LG X Power
WHERE content_id = 3245529;

UPDATE $tbl SET coop_product_id = 26088 # The Home Depot
WHERE content_id IN (3199488, 3208393);

UPDATE $tbl SET coop_product_id = 2782782 # Lowe's
WHERE content_id IN (3198591);

UPDATE $tbl SET coop_product_id = 2860223 # Samsung AddWash
WHERE content_id IN (3205884, 3199980);

UPDATE $tbl SET coop_product_id = 28103 # NCAA
WHERE content_id IN (3094632, 3234055, 3233298, 3233313, 3233540, 3234115, 3234025, 3233439, 3029736,
					 2929417);
# 3094632 belongs to 'NCAA March Madness'

UPDATE $tbl SET coop_product_id = 2768420 # Red Bull, though content 3205510 belongs to 'Red Bull Racing'
WHERE content_id IN (3205510);

UPDATE $tbl SET coop_product_id = 3057740 # Galaxy J3
WHERE content_id IN (3222352, 3220274, 3244513);
# 3244513 should be Galaxy J3 Emerge

UPDATE $tbl SET coop_product_id = 2827146 # TOMS
WHERE content_id IN (3178421);

UPDATE $tbl SET coop_product_id = 2766852 # Walmart
WHERE content_id IN (3201599, 3201921);

UPDATE $tbl SET coop_product_id = 28138 # Best Buy
WHERE content_id IN (3227430, 3242332, 2504786, 2400846, 2407215);

UPDATE $tbl SET coop_product_id = 2596000001 # Microsoft Word
WHERE content_id IN (3230172, 3230697);

UPDATE $tbl SET coop_product_id = 28096 # Netflix
WHERE content_id IN (3240168, 3239691, 3241838, 3241819);

UPDATE $tbl SET coop_product_id = 2847110 # MLB
WHERE content_id IN (3240396, 3240272, 3241260, 3241270, 3190494, 3030498, 2430880, 2400931);

UPDATE $tbl SET coop_product_id = 3145973 # Baywatch
WHERE content_id IN (3241553, 3242195, 3242064, 3243098, 3242893);

UPDATE $tbl SET coop_product_id = 27556 # HBO
WHERE content_id IN (3239185, 3238922, 3239918, 3241754, 3242623, 3243436);

UPDATE $tbl SET coop_product_id = 2886507 # Tribeca Film Festival
WHERE content_id = 3240400;

UPDATE $tbl SET coop_product_id = 3248727 # Carpool Karaoke
WHERE content_id = 3241244;

UPDATE $tbl SET coop_product_id = 3097002 # Go90 App
WHERE content_id = 3127674;

UPDATE $tbl SET coop_product_id = 3054514 # Google Home
WHERE content_id = 3235496;

UPDATE $tbl SET coop_product_id = 2774366 # HLN
WHERE content_id IN (3192997, 2919832);

UPDATE $tbl SET coop_product_id = 2769225 # HTC
WHERE content_id = 2413052;
# 2413052 should be mapped to HTC Desire

UPDATE $tbl SET coop_product_id = 2811347 # NBA App
WHERE content_id = 2397729;

UPDATE $tbl SET coop_product_id = 2765232 # NFL
WHERE content_id = 3208506;

UPDATE $tbl SET coop_product_id = 3122731 # NFL Mobile
WHERE content_id IN (2585949, 2407410, 2332547);

UPDATE $tbl SET coop_product_id = 2826380 # PGA
WHERE content_id = 2404792;

UPDATE $tbl SET coop_product_id = 2774418 # Plenti
WHERE content_id = 2400363;

UPDATE $tbl SET coop_product_id = 2952903 # Scream Queens
WHERE content_id = 2408002;

UPDATE $tbl SET coop_product_id = 2827419 # WALT DISNEY - STAR WARS THE FORCE AWAKENS
WHERE content_id IN (2581112, 2476018, 2504489);

UPDATE $tbl SET coop_product_id = 2770863 # Taylor Swift
WHERE content_id IN (3241324, 2622226);
# 3241324 should be mapped to Love Story

UPDATE $tbl SET coop_product_id = 2872998 # Viceland
WHERE content_id = 3000487;

UPDATE $tbl SET coop_product_id = 2818355 # Views by Drake
WHERE content_id = 3127604;

UPDATE $tbl SET coop_product_id = 2767577 # GLAAD
WHERE content_id IN (3243674, 3243742, 3243564, 3243725, 3243795, 3243673);

UPDATE $tbl SET coop_product_id = 2767241 # YouTube
WHERE content_id = 3244320;

UPDATE $tbl SET coop_product_id = 2398116 # TIDAL
WHERE content_id IN (3244928, 3245951, 3245998);

UPDATE $tbl SET coop_product_id = 3267819 # Prince Royce
WHERE content_id = 3243979;"