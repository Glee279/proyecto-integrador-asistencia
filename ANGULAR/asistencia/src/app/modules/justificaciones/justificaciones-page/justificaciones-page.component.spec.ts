import { ComponentFixture, TestBed } from '@angular/core/testing';

import { JustificacionesPageComponent } from './justificaciones-page.component';

describe('JustificacionesPageComponent', () => {
  let component: JustificacionesPageComponent;
  let fixture: ComponentFixture<JustificacionesPageComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [JustificacionesPageComponent]
    });
    fixture = TestBed.createComponent(JustificacionesPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
