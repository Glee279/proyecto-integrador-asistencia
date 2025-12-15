import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AprobacionesPageComponent } from './aprobaciones-page.component';

describe('AprobacionesPageComponent', () => {
  let component: AprobacionesPageComponent;
  let fixture: ComponentFixture<AprobacionesPageComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [AprobacionesPageComponent]
    });
    fixture = TestBed.createComponent(AprobacionesPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
