import { Test, TestingModule } from '@nestjs/testing';
import { TenantTypesController } from './tenant-types.controller';
import { TenantTypesService } from './tenant-types.service';

describe('TenantTypesController', () => {
  let controller: TenantTypesController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TenantTypesController],
      providers: [TenantTypesService],
    }).compile();

    controller = module.get<TenantTypesController>(TenantTypesController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
