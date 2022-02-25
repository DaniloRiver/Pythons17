########################## EjerciciO No4 ############################################
#Cree el procedimiento almacenado "sp_procesar_factura " que registre el proceso de facturación:
# Registra un producto de acuerdo un numero de factura en la tabla ítems factura
# Actualiza los valores de la factura con los valores totales

select * from bd_sample.tbl_items_factura;
select * from bd_sample.tbl_facturas;
DROP PROCEDURE bd_sample.SP_PROCESAR_FACTURA;

DELIMITER //
# crear procedimiento
CREATE PROCEDURE bd_sample.SP_PROCESAR_FACTURA(
	in p_id_factura      	int, 
    in p_id_producto        int,
    in p_cantidad 	        int
)
BEGIN
#definir variables

declare v_id_factura      	int;
declare v_id_producto       int;
declare v_cantidad 	        int;
declare v_numero_items      int;
declare v_precio_prod       decimal(12,2);


 #asignar valores de parametros a variables 
    set v_id_factura 		= p_id_factura;
	set v_id_producto	    = p_id_producto; 
    set v_cantidad      	= p_cantidad;
    set v_numero_items      = 0;
    set v_precio_prod       = 0.0;
   
  
 # 1. Registra un producto de acuerdo un numero de factura en la tabla ítems factura.
 insert into bd_sample.tbl_items_factura(
   id_factura, id_producto, cantidad
 )values( v_id_factura, v_id_producto, v_cantidad);
 
 #3. Actualizar resumen de facturas
 select sum(cantidad) into v_numero_items
 from bd_sample.tbl_items_factura 
 where id_factura = v_id_factura; 
 
  select precio_venta into v_precio_prod  
  from bd_sample.tbl_productos 
  where id_producto = v_id_producto; 
 
 
 update bd_sample.tbl_facturas
 set numero_items = v_numero_items,
	 isv_total = (subtotal + v_precio_prod * v_cantidad)*0.18, 
	 subtotal  =  subtotal + v_precio_prod * v_cantidad,
	 totapagar = (subtotal)*1.18
where id_factura =  v_id_factura;
 
 commit;
END;

# Ejecutar procedimiento 
CALL bd_sample.SP_PROCESAR_FACTURA(
    26, 					# p_id_factura 
	3,					    # p_id_producto
	2					    # p_cantidad

);

#Buscar factura actualizada
select * 
from bd_sample.tbl_facturas
where id_factura=26;


select * from bd_sample.tbl_items_factura where id_factura=26;
select * from bd_sample.tbl_productos;







 select *
 from bd_sample.tbl_items_factura 
 where id_factura = 19 and id_producto= 2 ;




