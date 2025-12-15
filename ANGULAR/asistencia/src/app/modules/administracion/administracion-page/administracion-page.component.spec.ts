import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AdministracionPageComponent } from './administracion-page.component';

describe('AdministracionPageComponent', () => {
  let component: AdministracionPageComponent;
  let fixture: ComponentFixture<AdministracionPageComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [AdministracionPageComponent]
    });
    fixture = TestBed.createComponent(AdministracionPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
