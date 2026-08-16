USE [DB_ECOMMERCE]
GO

CREATE OR ALTER TRIGGER [SQM_GENERAL].[trg_AntiFraud_OrderDetails]
ON [SQM_GENERAL].[Tbl_PaymentOrderDetails]
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM [SQM_GENERAL].[Tbl_PaymentOrders] o
        WHERE o.orderId IN (
            SELECT orderDetailOrderId FROM inserted
            UNION
            SELECT orderDetailOrderId FROM deleted
        )
        AND o.orderStatusId IN (4, 5) 
    )
    BEGIN
        RAISERROR('Alerta: No se pueden agregar, modificar ni eliminar productos de una orden que ya está en estado PROCESADO o ENTREGADO.', 16, 1);
        
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO