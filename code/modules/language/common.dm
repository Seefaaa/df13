// 'basic' language; spoken by default.
/datum/language/common
	name = "Common Language"
	desc = "Common language used across the world."
	key = "0"
	flags = TONGUELESS_SPEECH | LANGUAGE_HIDE_ICON_IF_UNDERSTOOD
	default_priority = 100

	icon_state = "galcom"

//Syllable Lists
/*
	This list really long, mainly because I can't make up my mind about which mandarin syllables should be removed,
	and the english syllables had to be duplicated so that there is roughly a 50-50 weighting.

	Sources:
	http://www.sttmedia.com/syllablefrequency-english
	http://www.chinahighlights.com/travelguide/learning-chinese/pinyin-syllables.htm
*/
/datum/language/common/syllables = list(
"a","ah",
"ai","eye",
"an","an",
"ang","ung",
"ao","ao",
"ba","bah",
"bai","buy",
"ban","ban",
"bang","bung",
"bao","bao",
"bei","bay",
"ben","bnn",
"beng","bnng",
"bi","bee",
"bian","byen",
"biao","byao",
"bie","byeah",
"bin","bin",
"bing","bing",
"bo","bor",
"bu","boo",
"ca","tsah",
"cai","tseye",
"can","tsan",
"cang","tsung",
"cao","tsao",
"ce","tser",
"cei","tsay",
"cen","tsnn",
"ceng","tsnng",
"cha","chah",
"chai","cheye",
"chan","chan",
"chang","chung",
"chao","chao",
"che","cher",
"chen","chnn",
"cheng","chnng",
"chi","chrr",
"chong","chong",
"chou","choh",
"chu","choo",
"chua","chwah",
"chuai","chwhy",
"chuan","chwan",
"chuang","chwung",
"chui","chway",
"chun","chwnn",
"chuo","chwor",
"ci","tsrr",
"cong","tsong",
"cou","tsoh",
"cu","tsoo",
"cuan","tswan",
"cui","tsway",
"cun","tswnn",
"cuo","tswor",
"da","dah",
"dai","deye",
"dan","dan",
"dang","dung",
"dao","dao",
"de1-4","der",
"de5","duh",
"dei","day",
"den","dnn",
"deng","dnng",
"di","dee",
"dian","dyen",
"diao","dyao",
"die","dyeah",
"ding","ding",
"diu","dyoh",
"dong","dong",
"dou","doh",
"du","doo",
"duan","dwan",
"dui","dway",
"dun","dwnn",
"duo","dwor",
"e","er",
"ei","ay",
"en","nn",
"er","urr",
"fa","fah",
"fan","fan",
"fang","fung",
"fei","fay",
"fen","fnn",
"feng","fnng",
"fo","for",
"fou","foh",
"fu","foo",
"ga","gah",
"gai","geye",
"gan","gan",
"gang","gung",
"gao","gao",
"ge1-4","ger",
"ge5","guh",
"gei","gay",
"gen","gnn",
"geng","gnng",
"gong","gong",
"gou","go",
"gu","goo",
"gua","gwah",
"guai","gwhy",
"guan","gwan",
"guang","gwung",
"gui","gway",
"gun","gwnn",
"guo","gwor",
"ha","hah",
"hai","hi",
"han","han",
"hang","hung",
"hao","hao",
"he","her",
"hei","hay",
"hen","hnn",
"heng","hnng",
"hm","hmm",
"hng","hng",
"hong","hong",
"hou","hoh",
"hu","hoo",
"hua","hwah",
"huai","hwhy",
"huan","hwan",
"huang","hwung",
"hui","hway",
"hun","hwnn",
"huo","hwor",
"ji","jee",
"jia","jyah",
"jian","jyen",
"jiang","jyang",
"jiao","jyao",
"jie","jyeah",
"jin","jin",
"jing","jing",
"jiong","jyong",
"jiu","jyoh",
"ju","jyoo",
"juan","jwen",
"jue","jwhere",
"jun","jwnn",
"ka","kah",
"kai","keye",
"kan","kan",
"kang","kung",
"kao","kao",
"ke","ker",
"kei","kay",
"ken","knn",
"keng","knng",
"kong","kong",
"kou","koh",
"ku","koo",
"kua","kwah",
"kuai","kwhy",
"kuan","kwan",
"kuang","kwung",
"kui","kway",
"kun","kwnn",
"kuo","kwor",
"lv","lyoo",
"la","lah",
"lai","leye",
"lan","lan",
"lang","lung",
"lao","lao",
"le","ler",
"lve","lyouair",
"lei","lay",
"leng","lnng",
"li","lee",
"lia","lyah",
"lian","lyen",
"liang","lyang",
"liao","lyao",
"lie","lyeah",
"lin","lin",
"ling","ling",
"liu","lyoh",
"long","long",
"lou","loh",
"lu","loo",
"luan","lwan",
"lun","lwnn",
"luo","lwor",
"m","mm",
"ma","mah",
"mai","meye",
"man","man",
"mang","mung",
"mao","mao",
"me","muh",
"mei","may",
"men","mnn",
"meng","mnng",
"mi","mee",
"mian","myen",
"miao","myao",
"mie","myeah",
"min","min",
"ming","ming",
"miu","myoo",
"mo","mor",
"mou","moh",
"mu","moo",
"n","nn",
"nv","nyoo",
"na","nah",
"nai","neye",
"nan","nan",
"nang","nanng",
"nao","nao",
"ne1-4","ner",
"ne5","nuh",
"nve","nyouair",
"nei","nay",
"nen","nnn",
"neng","nung",
"ng","nng",
"ni","nee",
"nian","nyen",
"niang","nyang",
"niao","nyao",
"nie","nyeah",
"nin","neen",
"ning","ning",
"niu","nyoh",
"nong","nong",
"nou","noh",
"nu","noo",
"nuan","nwan",
"nuo","nwor",
"o","or",
"ou","oh",
"pa","pah",
"pai","peye",
"pan","pan",
"pang","pung",
"pao","pao",
"pei","pay",
"pen","pnn",
"peng","pnng",
"pi","pee",
"pian","pyen",
"piao","pyao",
"pie","pyeah",
"pin","pin",
"ping","ping",
"po","por",
"pou","poh",
"pu","poo",
"qi","chee",
"qia","chyah",
"qian","chyan",
"qiang","chyang",
"qiao","chyao",
"qie","chyeah",
"qin","chin",
"qing","ching",
"qiong","chyong",
"qiu","chyoh",
"qu","chyoo",
"quan","chwen",
"que","chwhere",
"qun","chwnn",
"ran","ran",
"rang","rung",
"rao","rao",
"re","rer",
"ren","rnn",
"reng","rnng",
"ri","rrr",
"rong","rong",
"rou","roh",
"ru","roo",
"rua","rwah",
"ruan","rwan",
"rui","rway",
"run","rwnn",
"ruo","rwor",
"sa","sah",
"sai","seye",
"san","san",
"sang","sung",
"sao","sao",
"se","ser",
"sei","say",
"sen","snn",
"seng","snng",
"sha","shah",
"shai","sheye",
"shan","shan",
"shang","shung",
"shao","shao",
"she","sher",
"shei","shay",
"shen","shnn",
"sheng","shnng",
"shi","shrr",
"shou","shoh",
"shu","shoo",
"shua","shwah",
"shuai","shwhy",
"shuan","shwan",
"shuang","shwung",
"shui","shway",
"shun","shwnn",
"shuo","shwor",
"si","srr",
"song","song",
"sou","soh",
"su","soo",
"suan","swann",
"sui","sway",
"sun","swnn",
"suo","swor",
"ta","tah",
"tai","teye",
"tan","tan",
"tang","tung",
"tao","tao",
"te","ter",
"teng","tnng",
"ti","tee",
"tian","tyen",
"tiao","tyao",
"tie","tyeah",
"ting","ting",
"tong","tong",
"tou","toh",
"tu","too",
"tuan","twan",
"tui","tway",
"tun","twnn",
"tuo","twor",
"wa","wah",
"wai","why",
"wan","wan",
"wang","wung",
"wei","way",
"wen","wnn",
"weng","wnng",
"wo","wor",
"wu","woo",
"xi","sshee",
"xia","sshyah",
"xian","sshyen",
"xiang","sshyang",
"xiao","sshyao",
"xie","sshyeah",
"xin","sshin",
"xing","sshing",
"xiong","sshyong",
"xiu","sshyoh",
"xu","sshyoo",
"xuan","sshywen",
"xue","sshyouair",
"xun","sshwnn",
"ya","yah",
"yan","yen",
"yang","yang",
"yao","yao",
"ye","yeah",
"yi","ee",
"yin","yin",
"ying","ying",
"yong","yong",
"you","yoh",
"yu","yoo",
"yuan","ywhen",
"yue","yhwere",
"yun","ywnn",
"za","dzah",
"zai","dzeye",
"zan","dzan",
"zang","dzung",
"zao","dzao",
"ze","dzer",
"zei","dzay",
"zen","dznn",
"zeng","dznng",
"zha","jar",
"zhai","jeye",
"zhan","jan",
"zhang","jung",
"zhao","jao",
"zhe","jer",
"zhei","jay",
"zhen","jnn",
"zheng","jnng",
"zhi","jrr",
"zhong","jong",
"zhou","joh",
"zhu","joo",
"zhua","jwah",
"zhuai","jwhy",
"zhuan","jwan",
"zhuang","jwung",
"zhui","jway",
"zhun","jwnn",
"zhuo","jwor",
"zi1–4","dzrr",
"zi5","dzuh",
"zong","dzong",
"zou","dzoh",
"zuan","dzwan",
"zui","dzway",
"zun","dzwnn",
"zuo","dzwor",
"zu","dzoo")
