/***********Cave in flags**************/
///Flag for marking turfs already queued for processing to avoid dublicate calculations
#define CAVEIN_QUEUED (1<<0)
///Flag for turfs that ignore gravity, used for stuff like openspaces
#define CAVEIN_IGNORE (1<<1)
///Flag for turfs that are treated as openspace. This is an extra flag in case we want some extra behavior for some turfs
#define CAVEIN_AIR (1<<2)

///Define to queue a stability check for turf
#define QUEUE_CAVEIN(T) if(!(T.flags_cavein & CAVEIN_QUEUED)) {SScaveins.add_to_queue(T)}

///Maximum size of our cave in connected group
#define CAVEIN_MAX_SIZE 80
