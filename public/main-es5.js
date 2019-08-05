(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["main"],{

/***/ "./$$_lazy_route_resource lazy recursive":
/*!******************************************************!*\
  !*** ./$$_lazy_route_resource lazy namespace object ***!
  \******************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

function webpackEmptyAsyncContext(req) {
	// Here Promise.resolve().then() is used instead of new Promise() to prevent
	// uncaught exception popping up in devtools
	return Promise.resolve().then(function() {
		var e = new Error("Cannot find module '" + req + "'");
		e.code = 'MODULE_NOT_FOUND';
		throw e;
	});
}
webpackEmptyAsyncContext.keys = function() { return []; };
webpackEmptyAsyncContext.resolve = webpackEmptyAsyncContext;
module.exports = webpackEmptyAsyncContext;
webpackEmptyAsyncContext.id = "./$$_lazy_route_resource lazy recursive";

/***/ }),

/***/ "./node_modules/raw-loader/index.js!./src/app/app.component.html":
/*!**************************************************************!*\
  !*** ./node_modules/raw-loader!./src/app/app.component.html ***!
  \**************************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<div class=\"container\">\n  <div class=\"card text-white bg-dark mb-3\">\n    <div class=\"card-header\">Lackofleetiosis</div>\n    <div class=\"card-body\">\n      <p role=\"alert\" *ngFor=\"let message of messages\">{{message}}</p>\n\n      <form class=\"form-inline\" [formGroup]=\"form\" (ngSubmit)=\"addVehicle(form.value)\">\n        <div class=\"form-group mx-sm-3 mb-2\">\n          <input class=\"form-control\" placeholder=\"VIN\" type=\"text\" formControlName=\"vin\">\n        </div>\n\n        <button class=\"btn btn-primary mb-2\" type=\"submit\" [disabled]=\"loading\">\n          <span *ngIf=\"!loading\">Add Vehicle</span>\n          <em *ngIf=\"loading\">one moment...</em>\n        </button>\n      </form>\n    </div>\n  </div>\n\n  <div class=\"row\">\n    <div class=\"col-xs-3 col-md-4\" *ngFor=\"let vehicle of vehicles\">\n      <div class=\"card\">\n        <img class=\"card-img-top\" *ngIf=\"vehicle.image_url\" [src]=\"vehicle.image_url\">\n        <img class=\"card-img-top\" *ngIf=\"!vehicle.image_url\" src=\"assets/default.png\">\n\n        <div class=\"card-body\">\n          <h5 class=\"card-title\">{{vehicle.year}} {{vehicle.make}} {{vehicle.model}}</h5>\n          <h6 class=\"card-subtitle mb-2 text-muted\">{{vehicle.vin}}</h6>\n        </div>\n\n        <ul class=\"list-group list-group-flush\">\n          <li class=\"list-group-item\"><strong>Trim:</strong> {{vehicle.trim}}</li>\n          <li class=\"list-group-item\"><strong>Color:</strong> {{vehicle.color}}</li>\n          <li class=\"list-group-item\">\n            <strong>Efficiency: </strong>\n\n            <span *ngIf=\"vehicle.status == 'processed'\">\n              {{vehicle.efficiency || 'N/A'}}\n            </span>\n\n            <span *ngIf=\"vehicle.status == 'unprocessed'\">\n              <em>calculating...</em>\n              &nbsp;\n              <button class=\"btn btn-primary mb-2\" (click)=\"loadVehicles()\">Refresh</button>\n            </span>\n\n            <span *ngIf=\"vehicle.status == 'error'\">\n              <button class=\"btn btn-primary mb-2\" (click)=\"reprocessVehicle(vehicle)\">Calculate</button>\n            </span>\n          </li>\n        </ul>\n      </div>\n      <br>\n    </div>\n  </div>\n\n  <div class=\"row\" *ngIf=\"vehicles.length == 0\">\n    <div class=\"col-xs-3 col-md-4\">\n      <p class=\"alert alert-info\" role=\"alert\">No vehicles have been added.</p>\n      <img src=\"https://media.giphy.com/media/dYQh2AcRNN6Jq/giphy.gif\">\n    </div>\n  </div>\n</div>\n"

/***/ }),

/***/ "./src/app/app.component.css":
/*!***********************************!*\
  !*** ./src/app/app.component.css ***!
  \***********************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsImZpbGUiOiJzcmMvYXBwL2FwcC5jb21wb25lbnQuY3NzIn0= */"

/***/ }),

/***/ "./src/app/app.component.ts":
/*!**********************************!*\
  !*** ./src/app/app.component.ts ***!
  \**********************************/
/*! exports provided: AppComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "AppComponent", function() { return AppComponent; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_forms__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/forms */ "./node_modules/@angular/forms/fesm5/forms.js");
/* harmony import */ var _vehicles_service__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./vehicles.service */ "./src/app/vehicles.service.ts");




var AppComponent = /** @class */ (function () {
    function AppComponent(vehiclesService, formBuilder) {
        this.vehiclesService = vehiclesService;
        this.formBuilder = formBuilder;
        this.messages = [];
        this.vehicles = [];
        this.loading = false;
        this.form = this.formBuilder.group({ vin: '' });
        this.loadVehicles();
    }
    AppComponent.prototype.loadVehicles = function () {
        var _this = this;
        this.vehiclesService.fetch().subscribe(function (vehicles) { return _this.vehicles = vehicles; });
    };
    AppComponent.prototype.addVehicle = function (vehicle) {
        var _this = this;
        this.loading = true;
        this.messages = [];
        this.vehiclesService.add(vehicle).subscribe(function (res) {
            _this.loadVehicles();
            _this.form.reset();
            _this.loading = false;
        }, function (err) {
            _this.loading = false;
            _this.messages = err.error.errors;
        });
    };
    AppComponent.prototype.reprocessVehicle = function (vehicle) {
        var _this = this;
        this.vehiclesService.reprocess(vehicle).subscribe(function (data) { return _this.loadVehicles(); });
    };
    AppComponent.ctorParameters = function () { return [
        { type: _vehicles_service__WEBPACK_IMPORTED_MODULE_3__["VehiclesService"] },
        { type: _angular_forms__WEBPACK_IMPORTED_MODULE_2__["FormBuilder"] }
    ]; };
    AppComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
            selector: 'app-root',
            template: __webpack_require__(/*! raw-loader!./app.component.html */ "./node_modules/raw-loader/index.js!./src/app/app.component.html"),
            styles: [__webpack_require__(/*! ./app.component.css */ "./src/app/app.component.css")]
        })
    ], AppComponent);
    return AppComponent;
}());



/***/ }),

/***/ "./src/app/app.module.ts":
/*!*******************************!*\
  !*** ./src/app/app.module.ts ***!
  \*******************************/
/*! exports provided: AppModule */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "AppModule", function() { return AppModule; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_platform_browser__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/platform-browser */ "./node_modules/@angular/platform-browser/fesm5/platform-browser.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_forms__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! @angular/forms */ "./node_modules/@angular/forms/fesm5/forms.js");
/* harmony import */ var _angular_common_http__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! @angular/common/http */ "./node_modules/@angular/common/fesm5/http.js");
/* harmony import */ var _app_component__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./app.component */ "./src/app/app.component.ts");






var AppModule = /** @class */ (function () {
    function AppModule() {
    }
    AppModule = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_2__["NgModule"])({
            declarations: [
                _app_component__WEBPACK_IMPORTED_MODULE_5__["AppComponent"]
            ],
            imports: [
                _angular_platform_browser__WEBPACK_IMPORTED_MODULE_1__["BrowserModule"],
                _angular_forms__WEBPACK_IMPORTED_MODULE_3__["ReactiveFormsModule"],
                _angular_common_http__WEBPACK_IMPORTED_MODULE_4__["HttpClientModule"]
            ],
            providers: [],
            bootstrap: [_app_component__WEBPACK_IMPORTED_MODULE_5__["AppComponent"]]
        })
    ], AppModule);
    return AppModule;
}());



/***/ }),

/***/ "./src/app/vehicles.service.ts":
/*!*************************************!*\
  !*** ./src/app/vehicles.service.ts ***!
  \*************************************/
/*! exports provided: VehiclesService */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "VehiclesService", function() { return VehiclesService; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_common_http__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/common/http */ "./node_modules/@angular/common/fesm5/http.js");
/* harmony import */ var rxjs__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! rxjs */ "./node_modules/rxjs/_esm5/index.js");
/* harmony import */ var rxjs_operators__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! rxjs/operators */ "./node_modules/rxjs/_esm5/operators/index.js");





var httpOptions = {
    headers: new _angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpHeaders"]({ 'Content-Type': 'application/json' })
};
var VehiclesService = /** @class */ (function () {
    function VehiclesService(http) {
        this.http = http;
    }
    VehiclesService.prototype.add = function (vehicle) {
        return this.http.post('http://localhost:3000/vehicles', vehicle, httpOptions).pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["catchError"])(this.handleError));
    };
    VehiclesService.prototype.fetch = function () {
        return this.http.get('http://localhost:3000/vehicles').pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["catchError"])(this.handleError));
    };
    VehiclesService.prototype.reprocess = function (vehicle) {
        return this.http.post("http://localhost:3000/vehicles/" + vehicle.id + "/reprocess", null).pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["catchError"])(this.handleError));
    };
    VehiclesService.prototype.handleError = function (error) {
        console.error(error);
        return Object(rxjs__WEBPACK_IMPORTED_MODULE_3__["throwError"])(error);
    };
    VehiclesService.ctorParameters = function () { return [
        { type: _angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpClient"] }
    ]; };
    VehiclesService = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Injectable"])({
            providedIn: 'root'
        })
    ], VehiclesService);
    return VehiclesService;
}());



/***/ }),

/***/ "./src/environments/environment.ts":
/*!*****************************************!*\
  !*** ./src/environments/environment.ts ***!
  \*****************************************/
/*! exports provided: environment */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "environment", function() { return environment; });
// This file can be replaced during build by using the `fileReplacements` array.
// `ng build --prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.
var environment = {
    production: false
};
/*
 * For easier debugging in development mode, you can import the following file
 * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
 *
 * This import should be commented out in production mode because it will have a negative impact
 * on performance if an error is thrown.
 */
// import 'zone.js/dist/zone-error';  // Included with Angular CLI.


/***/ }),

/***/ "./src/main.ts":
/*!*********************!*\
  !*** ./src/main.ts ***!
  \*********************/
/*! no exports provided */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_platform_browser_dynamic__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/platform-browser-dynamic */ "./node_modules/@angular/platform-browser-dynamic/fesm5/platform-browser-dynamic.js");
/* harmony import */ var _app_app_module__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./app/app.module */ "./src/app/app.module.ts");
/* harmony import */ var _environments_environment__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./environments/environment */ "./src/environments/environment.ts");




if (_environments_environment__WEBPACK_IMPORTED_MODULE_3__["environment"].production) {
    Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["enableProdMode"])();
}
Object(_angular_platform_browser_dynamic__WEBPACK_IMPORTED_MODULE_1__["platformBrowserDynamic"])().bootstrapModule(_app_app_module__WEBPACK_IMPORTED_MODULE_2__["AppModule"])
    .catch(function (err) { return console.error(err); });


/***/ }),

/***/ 0:
/*!***************************!*\
  !*** multi ./src/main.ts ***!
  \***************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(/*! /Users/austin/projects/lackofleetiosis/ui/src/main.ts */"./src/main.ts");


/***/ })

},[[0,"runtime","vendor"]]]);
//# sourceMappingURL=main-es5.js.map