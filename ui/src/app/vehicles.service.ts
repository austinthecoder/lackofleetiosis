import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpErrorResponse } from '@angular/common/http';
import { Observable, of, throwError } from 'rxjs';
import { catchError, tap, map } from 'rxjs/operators';
import { Vehicle } from './vehicle';

const httpOptions = {
  headers: new HttpHeaders({'Content-Type': 'application/json'})
};

@Injectable({
  providedIn: 'root'
})
export class VehiclesService {
  constructor(private http: HttpClient) {}

  add(vehicle: Vehicle): Observable<Vehicle> {
    return this.http.post<Vehicle>('http://localhost:3000/vehicles', vehicle, httpOptions).pipe(
      catchError(this.handleError)
    );
  }

  fetch(): Observable<Vehicle[]> {
    return this.http.get<Vehicle[]>('http://localhost:3000/vehicles').pipe(
      catchError(this.handleError)
    );
  }

  reprocess(vehicle: Vehicle): Observable<any> {
    return this.http.post(`http://localhost:3000/vehicles/${vehicle.id}/reprocess`, null).pipe(
      catchError(this.handleError)
    );
  }

  private handleError(error: any) {
    console.error(error);
    return throwError(error);
  }
}
