// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include "../inst/include/qtlpvl.h"
#include <RcppEigen.h>
#include <Rcpp.h>

using namespace Rcpp;

// lm_resid_svd
MatrixXd lm_resid_svd(const MapMatd& X, const MapMatd& Y, const double threshold);
RcppExport SEXP qtlpvl_lm_resid_svd(SEXP XSEXP, SEXP YSEXP, SEXP thresholdSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< const MapMatd& >::type X(XSEXP);
    Rcpp::traits::input_parameter< const MapMatd& >::type Y(YSEXP);
    Rcpp::traits::input_parameter< const double >::type threshold(thresholdSEXP);
    __result = Rcpp::wrap(lm_resid_svd(X, Y, threshold));
    return __result;
END_RCPP
}
// lm_resid_llt
MatrixXd lm_resid_llt(const MapMatd& X, const MapMatd& Y);
RcppExport SEXP qtlpvl_lm_resid_llt(SEXP XSEXP, SEXP YSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< const MapMatd& >::type X(XSEXP);
    Rcpp::traits::input_parameter< const MapMatd& >::type Y(YSEXP);
    __result = Rcpp::wrap(lm_resid_llt(X, Y));
    return __result;
END_RCPP
}
// lm_resid_qr
MatrixXd lm_resid_qr(const MapMatd& X, const MapMatd& Y);
RcppExport SEXP qtlpvl_lm_resid_qr(SEXP XSEXP, SEXP YSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< const MapMatd& >::type X(XSEXP);
    Rcpp::traits::input_parameter< const MapMatd& >::type Y(YSEXP);
    __result = Rcpp::wrap(lm_resid_qr(X, Y));
    return __result;
END_RCPP
}
// lm_resid_symmEigen
MatrixXd lm_resid_symmEigen(const MapMatd& X, const MapMatd& Y, const double threshold);
RcppExport SEXP qtlpvl_lm_resid_symmEigen(SEXP XSEXP, SEXP YSEXP, SEXP thresholdSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< const MapMatd& >::type X(XSEXP);
    Rcpp::traits::input_parameter< const MapMatd& >::type Y(YSEXP);
    Rcpp::traits::input_parameter< const double >::type threshold(thresholdSEXP);
    __result = Rcpp::wrap(lm_resid_symmEigen(X, Y, threshold));
    return __result;
END_RCPP
}
// lm_resid_cov
MatrixXd lm_resid_cov(const MapMatd& X, const MapMatd& Y, const double threshold);
RcppExport SEXP qtlpvl_lm_resid_cov(SEXP XSEXP, SEXP YSEXP, SEXP thresholdSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< const MapMatd& >::type X(XSEXP);
    Rcpp::traits::input_parameter< const MapMatd& >::type Y(YSEXP);
    Rcpp::traits::input_parameter< const double >::type threshold(thresholdSEXP);
    __result = Rcpp::wrap(lm_resid_cov(X, Y, threshold));
    return __result;
END_RCPP
}
// lm_resid_cov_det
double lm_resid_cov_det(const MapMatd& X, const MapMatd& Y, const bool logarithm, const double threshold);
RcppExport SEXP qtlpvl_lm_resid_cov_det(SEXP XSEXP, SEXP YSEXP, SEXP logarithmSEXP, SEXP thresholdSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< const MapMatd& >::type X(XSEXP);
    Rcpp::traits::input_parameter< const MapMatd& >::type Y(YSEXP);
    Rcpp::traits::input_parameter< const bool >::type logarithm(logarithmSEXP);
    Rcpp::traits::input_parameter< const double >::type threshold(thresholdSEXP);
    __result = Rcpp::wrap(lm_resid_cov_det(X, Y, logarithm, threshold));
    return __result;
END_RCPP
}
// det_AtA
double det_AtA(const MapMatd& X, bool logarithm);
RcppExport SEXP qtlpvl_det_AtA(SEXP XSEXP, SEXP logarithmSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< const MapMatd& >::type X(XSEXP);
    Rcpp::traits::input_parameter< bool >::type logarithm(logarithmSEXP);
    __result = Rcpp::wrap(det_AtA(X, logarithm));
    return __result;
END_RCPP
}