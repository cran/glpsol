## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ----setup--------------------------------------------------------------------
library(glpsol)

## ----where--------------------------------------------------------------------
glpsol_path()
glpk_version()

## ----solve--------------------------------------------------------------------
mod <- system.file("models", "transp.mod", package = "glpsol")

out <- tempfile("glpsol-")
dir.create(out)
sol <- file.path(out, "transp.sol")

res <- glpsol_run(c("-m", mod, "-o", sol), echo = FALSE)
res$status

## ----log----------------------------------------------------------------------
tail(res$log, 4)

## ----readsol------------------------------------------------------------------
writeLines(head(readLines(sol), 12))
grep("^Status", readLines(sol), value = TRUE)

## ----readback-----------------------------------------------------------------
txt <- file.path(out, "transp.txt")
glp <- file.path(out, "transp.glp")
glpsol_run(c("-m", mod, "-w", txt, "--wglp", glp), echo = FALSE)

s <- glpsol_read_solution(txt, names = glp)
s
s$cols[, c("name", "status", "primal", "dual")]
s$rows[, c("name", "primal", "dual")]

## ----timeout------------------------------------------------------------------
res <- glpsol_run(c("-m", mod), echo = FALSE, timeout = 60)
res$timed_out

## ----cleanup, include = FALSE-------------------------------------------------
unlink(out, recursive = TRUE)

