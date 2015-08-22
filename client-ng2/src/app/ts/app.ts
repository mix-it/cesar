/// <reference path="../../../typings/angular2/angular2.d.ts" />
/// <reference path="components/menu.ts" />

import {Component, View, bootstrap} from 'angular2/angular2';
import {CesarMenuComponent} from './components/menu';

// Annotation section
@Component({
    selector: 'cesar-app'
})
@View({
    templateUrl: 'views/app.html',
    directives: [CesarMenuComponent]
})
// Component controller
class CesarAppComponent {
    name: string;
    constructor() {
        this.name = 'Alice';
    }
}

bootstrap(CesarAppComponent);