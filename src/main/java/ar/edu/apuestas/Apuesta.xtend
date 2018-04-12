package ar.edu.apuestas

import java.math.BigDecimal
import java.util.Date
import java.util.Random
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Dependencies
import org.uqbar.commons.model.annotations.TransactionalAndObservable
import org.uqbar.commons.model.exceptions.UserException
import org.uqbar.commons.model.utils.ObservableUtils

@TransactionalAndObservable
@Accessors
class Apuesta {
	Date fecha
	BigDecimal monto
	TipoApuesta tipo
	Object valorApostado
	Resultado resultado

	val hoy = new Date()
	
	@Dependencies("valorApostado", "monto", "tipo", "fecha")
	def getPuedeJugar() {
		fecha != null && fecha.after(hoy) 
			&& monto != null && monto > BigDecimal.ZERO
			&& tipo != null
			&& valorApostado != null
	}

	def void setMonto(BigDecimal unMonto) {
		if (unMonto == null || unMonto <= BigDecimal.ZERO) 
			throw new UserException("El monto debe ser positivo.")

		this.monto = unMonto
//		ObservableUtils.firePropertyChanged(this, "monto", this.monto)
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
