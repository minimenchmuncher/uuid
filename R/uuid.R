

UUIDgenerate <- function(use.time = NA) .Call(UUID_gen, use.time)


setClass("uuid", representation(
    time_low = "numeric",
    time_mid = "numeric",
    time_hi_and_version = "numeric",
    node = "numeric",
    char_repr = "character",
    raw = "raw"),
    prototype(time_low = 0, time_mid = 0, time_hi_and_version = 0, node = rep(0, 6))
) -> UUID

setMethod("initialize", "uuid", function(.Object, time_low, time_mid,
                                         time_hi_and_version, node, char_repr, raw,
                                         ...) {
    if (missing(raw))...
})

uuidFromCharacter <- function(x) {

}
