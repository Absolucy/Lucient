#import <Foundation/Foundation.h>
#import <stdint.h>

/// Get the current device's UDID in a hard-to-spoof manner.
extern NSString* udid();
/// Get the current device's model identifier in a hard-to-spoof manner.
extern NSString* model();
/// Ensure that the "good" package identifiers are installed, and not the "bad" identifiers.
extern BOOL dpkg_check();
/// Initialize the string table. This should only be run once, during initialization!
extern void initialize_string_table();

typedef struct {
	uint32_t length;
	uint8_t* data;
} decrypted_data;

/// Get a string from the string table, automatically decrypting it.
/// You must free() this string later!
extern char* st_get(uint32_t idx);

/// Get some arbritrary data from the string table, automatically decrypting it.
/// You must free() this data later!
extern decrypted_data st_get_bytes(uint32_t idx);
