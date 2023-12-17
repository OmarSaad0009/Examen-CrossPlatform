package org.isetn.entities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Classe {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long codClass;
	private String nomClass;
	private int nbreEtud;

	@JsonIgnore
	@OneToMany(mappedBy = "classe")
	private List<Etudiant> etudiants;

	@ManyToMany(cascade = CascadeType.MERGE)
	@JoinTable(name = "classe_matiere", joinColumns = @JoinColumn(name = "classe_id"), inverseJoinColumns = @JoinColumn(name = "matiere_id"))
	private Set<Matiere> matieres = new HashSet<>();

	public Classe(Long codClass, String nomClass, int nbreEtud, Collection<Etudiant> etudiants) {
		this.codClass = codClass;
		this.nomClass = nomClass;
		this.nbreEtud = nbreEtud;
		this.etudiants = (List<Etudiant>) etudiants;
	}
}
