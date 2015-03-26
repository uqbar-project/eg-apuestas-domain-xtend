package ar.edu.apuestas

import java.math.BigDecimal
import java.util.Date
import java.util.Random
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.TransactionalAndObservable

import static org.uqbar.commons.model.ObservableUtils.*

@TransactionalAndObservable
@Accessors
class Apuesta {
	Date fecha
	BigDecimal monto
	TipoApuesta tipo
	Object valorApostado
	Resultado resultado

	val hoy = new Date()
	
	def isPuedeJugar() {
		fecha != null && fecha.after(hoy) 
			&& monto != null && monto > BigDecimal.ZERO
			&& tipo != null
			&& valorApostado != null
	}

	def void setFecha(Date unaFecha) {
		this.fecha = unaFecha
		cambioPuedeApostar
	}
	
	def void setTipo(TipoApuesta tipoApuesta) {
		this.tipo = tipoApuesta
		cambioPuedeApostar
	}
	
	def void setValorApostado(Object valor) {
		this.valorApostado = valor
		cambioPuedeApostar
	}
	
	def cambioPuedeApostar() {
		firePropertyChanged(this, "puedeJugar", puedeJugar)
	}

	def void setMonto(BigDecimal unMonto) {
		if (unMonto == null || unMonto <= BigDecimal.ZERO) 
			throw new UserException("El monto debe ser positivo.")

		this.monto = unMonto
		cambioPuedeApostar
	}

	def jugar() {
		tipo.validarMontoMinimo(monto)

		val ganador = new Random().nextInt(37)
		resultado = tipo.chequearApuesta(ganador, this)
	}
	
	def getTiposPosibles() {
		#[new ApuestaPleno, new ApuestaDocena]
	}

}
