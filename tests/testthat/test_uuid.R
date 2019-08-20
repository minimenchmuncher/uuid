context("get new uuids")

test_that("get a UUID string", {
    x <- getNewUUID()
    expect_equal(nchar(x), 36)
})

test_that("convert char to raw and back", {
    x <- getNewUUID()
    b <- .ConvertCharToRaw(x)
    x2 <- .ConvertRawToChar(b)
    expect_equal(x, x2)
})

test_that("get a uuid object", {
    x <- uuid()
    expect_is(x, "uuid")

    x <- uuid("00000000-0000-0000-0000-000000000000")
    expect_is(x, "uuid")

    browser()
    v <- raw(16)
    x <- uuid(raw = v)
    expect_is(x, "uuid")

})
