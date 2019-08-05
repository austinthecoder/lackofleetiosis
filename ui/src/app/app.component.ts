import { Component } from '@angular/core';
import { FormControl, FormGroupDirective, FormBuilder, FormGroup, NgForm, Validators } from '@angular/forms';
import { VehiclesService } from './vehicles.service';
import { Vehicle } from './vehicle';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  form;
  messages = [];
  vehicles: Vehicle[] = [];
  loading = false;

  constructor(
    private vehiclesService: VehiclesService,
    private formBuilder: FormBuilder
  ) {
    this.form = this.formBuilder.group({vin: ''});
    this.loadVehicles();
  }

  loadVehicles() {
    this.vehiclesService.fetch().subscribe(vehicles => this.vehicles = vehicles);
  }

  addVehicle(vehicle: Vehicle) {
    this.loading = true;
    this.messages = [];

    this.vehiclesService.add(vehicle).subscribe(
      res => {
        this.loadVehicles();
        this.form.reset();
        this.loading = false;
      }, (err) => {
        this.loading = false;
        this.messages = err.error.errors;
      }
    );
  }

  reprocessVehicle(vehicle: Vehicle) {
    this.vehiclesService.reprocess(vehicle).subscribe(data => this.loadVehicles())
  }

}
