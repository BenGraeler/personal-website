# Figures for copulas.qmd. Run from the repository root:
#   Rscript _scripts/copula-figures.R
# Writes SVGs with a transparent background and mid-grey axes so they work
# with both the light and the dark site theme.

library(copula)

out_dir <- "images/copulas"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

pt_col <- adjustcolor("#3a8fb0", alpha.f = 0.55)
fg_col <- "#8a8f98"

panel_par <- function(n_panels) {
  par(mfrow = c(1, n_panels), mar = c(4, 4, 3, 1), bg = "transparent",
      fg = fg_col, col.axis = fg_col, col.lab = fg_col, col.main = fg_col,
      cex.main = 1, font.main = 1, las = 1)
}

scatter <- function(x, y, main, xlab = "X", ylab = "Y", unit = FALSE) {
  lim <- if (unit) c(0, 1) else NULL
  plot(x, y, pch = 16, cex = 0.6, col = pt_col, main = main,
       xlab = xlab, ylab = ylab, xlim = lim, ylim = lim, asp = if (unit) 1 else NA)
}

fmt <- function(v) formatC(v, format = "f", digits = 2)

# Figure 1: same dependence, different margins -----------------------------
set.seed(42)
n <- 500
u <- rCopula(n, normalCopula(0.7))
x_norm <- qnorm(u)
x_lnorm <- qlnorm(u, sdlog = 1)
u_rank <- pobs(x_lnorm)

svg(file.path(out_dir, "margins-vs-copula.svg"), width = 10, height = 3.6)
panel_par(3)
scatter(x_norm[, 1], x_norm[, 2],
        sprintf("Normal margins\nPearson %s, Kendall %s",
                fmt(cor(x_norm)[1, 2]), fmt(cor(x_norm, method = "kendall")[1, 2])))
scatter(x_lnorm[, 1], x_lnorm[, 2],
        sprintf("Log-normal margins\nPearson %s, Kendall %s",
                fmt(cor(x_lnorm)[1, 2]), fmt(cor(x_lnorm, method = "kendall")[1, 2])))
scatter(u_rank[, 1], u_rank[, 2],
        "Both after rank transformation\n(identical)",
        xlab = "U = rank(X) / (n + 1)", ylab = "V = rank(Y) / (n + 1)", unit = TRUE)
dev.off()

# Figure 2: four families, one Kendall's tau --------------------------------
tau <- 0.5
fams <- list(
  "Gaussian" = normalCopula(iTau(normalCopula(), tau)),
  "Clayton" = claytonCopula(iTau(claytonCopula(), tau)),
  "Gumbel" = gumbelCopula(iTau(gumbelCopula(), tau)),
  "Frank" = frankCopula(iTau(frankCopula(), tau))
)

set.seed(1)
svg(file.path(out_dir, "copula-families.svg"), width = 10, height = 2.9)
panel_par(4)
par(mar = c(4, 4, 2.5, 0.5))
for (nm in names(fams)) {
  s <- rCopula(n, fams[[nm]])
  scatter(s[, 1], s[, 2], nm, xlab = "U", ylab = "V", unit = TRUE)
}
dev.off()

# Figure 3: multivariate return periods ------------------------------------
# Uses the flood peak/volume sample of the MRP demo in sfcopula
# (remotes::install_github("BenGraeler/sfcopula")).
library(sfcopula)
data("simulatedTriples")
pv <- as.matrix(rankTransform(triples[, 1], triples[, 3]))

cop <- claytonCopula(coef(fitCopula(claytonCopula(), pv, method = "ml")))
th <- cop@parameters
kendall <- function(t) t + t * (1 - t^th) / th
t_or <- 1 - 1 / 10
t_ken <- uniroot(function(t) kendall(t) - t_or, c(0.01, 0.9999))$root

g <- seq(0.5, 1, length.out = 301)
grid <- as.matrix(expand.grid(g, g))
cdf <- matrix(pCopula(grid, cop), length(g))
surv <- 1 - grid[, 1] - grid[, 2] + cdf  # P(U > u, V > v)
surv <- matrix(surv, length(g))

line_cols <- c(or = "#e07a1f", ken = "#8e5cc8", and = "#2a9d4a")

svg(file.path(out_dir, "return-periods.svg"), width = 5.6, height = 5.2)
panel_par(1)
par(mar = c(4, 4, 1, 1))
in_view <- pv[, 1] >= 0.5 & pv[, 2] >= 0.5
plot(pv[in_view, 1], pv[in_view, 2], pch = 16, cex = 0.6, col = pt_col,
     xlim = c(0.5, 1), ylim = c(0.5, 1), asp = 1,
     xlab = "Peak discharge (U)", ylab = "Flood volume (V)")
contour(g, g, cdf, levels = t_or, add = TRUE, drawlabels = FALSE,
        col = line_cols["or"], lwd = 2.5)
contour(g, g, cdf, levels = t_ken, add = TRUE, drawlabels = FALSE,
        col = line_cols["ken"], lwd = 2.5)
contour(g, g, surv, levels = 1 - t_or, add = TRUE, drawlabels = FALSE,
        col = line_cols["and"], lwd = 2.5)
legend("topleft", c("OR", "Kendall", "AND"), col = line_cols, lwd = 2.5,
       bty = "n", text.col = fg_col, title = "10-year critical lines",
       title.col = fg_col)
dev.off()
