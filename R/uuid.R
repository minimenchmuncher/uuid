
#' @useDynLib uuid UUID_gen
getNewUUID <- function(use.time = FALSE) .Call(UUID_gen, use.time)

cleanUUIDChar <- function(x) gsub("[^0-9a-z]", "", tolower(x))

checkUUID <- function(object) {
    errors <- character()

    lengthCharRepr <- length(object@char_repr)
    if (lengthCharRepr != 1) {
        msg <- sprintf("character representation length must be 1, was %i", lengthCharRepr)
        errors <- c(errors, msg)
    }

    # lengthRaw <- length(object@raw)
    # if (lengthRaw != 16) {
    #     msg <- sprintf("raw representation length must be 16 bytes, was %i", lengthRaw)
    #     errors <- c(errors, msg)
    # }

    ncharCharRepr <- nchar(cleanUUIDChar(head(object@char_repr, 1)))
    if (ncharCharRepr != 32) {
        msg <- sprintf("character representation length must be 32, was %i", ncharCharRepr)
        errors <- c(errors, msg)
    }
    if (length(errors) == 0) TRUE else errors
}

#' UUID Class
#' @slot char_repr Character representation of the UUID
#' @slot raw Raw (bytes) representation of the UUID
#' @export
setClass("uuid", representation(
    # time_low = "numeric",
    # time_mid = "numeric",
    # time_hi_and_version = "numeric",
    # node = "numeric",
    char_repr = "character",
    raw = "raw"),
    prototype(char_repr = "00000000-0000-0000-0000-000000000000", raw(16L)),
    validity = checkUUID
)

#' @export
uuid <- function(char_repr, raw, use.time = FALSE) {
    new("uuid", char_repr = char_repr, raw = raw, use.time = use.time)
}

#' @export
setMethod("initialize", "uuid", function(.Object, char_repr, raw, ..., use.time = FALSE) {
    if (missing(raw) && missing(char_repr)) {
        .Object@char_repr <- getNewUUID(use.time)
        .Object@raw <- .ConvertCharToRaw(.Object@char_repr)
    } else if (missing(raw)) {
        .Object@raw <- .ConvertCharToRaw(char_repr)
    } else if (missing(char_repr)) {
        .Object@char_repr <- .ConvertRawToChar(raw)
    }
    validObject(.Object)
    callNextMethod(.Object, ...)
})

#' Convert raw 16-byte vector to UUID character representation
#' @param x A raw vector, must be 16 byte
#' @return Returns a well-formed string representation of the UUID.
#' @examples
#' .ConvertRawToChar(raw(16))
.ConvertRawToChar <- function(x) {
    sprintf("%s-%s-%s-%s-%s", paste(x[1:4], collapse = ""),
                                  paste(x[5:6], collapse = ""),
                                  paste(x[7:8], collapse = ""),
                                  paste(x[9:10], collapse = ""),
                                  paste(x[11:16], collapse = ""))
}

#' Convert character string to UUID raw representation
#' @param x A string; may be in upper or lower-case
#' @return Returns a raw vector of 16 bytes
#' @examples
#' .ConvertCharToRaw("00000000-0000-0000-0000-000000000000")
.ConvertCharToRaw <- function(x) {
    cleanedChar <- cleanUUIDChar(x)
    r <- raw(16)
    for (i in 1:length(r)) {
        ind <- i * 2 - 1
        b <- paste0("0x", substr(cleanedChar, ind, ind + 1))
        r[i] <- as.raw(b)
    }
    r
}
