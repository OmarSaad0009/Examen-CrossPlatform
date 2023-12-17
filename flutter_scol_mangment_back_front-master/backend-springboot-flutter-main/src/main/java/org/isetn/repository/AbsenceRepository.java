package org.isetn.repository;


import java.util.Date;
import java.util.List;


import org.isetn.entities.Absence;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AbsenceRepository extends JpaRepository<Absence, Long> {
    // You can add custom query methods here if needed
    List<Absence> findByEtudiantId(Long codClass);
  //  List<Absence> findByMatiereMatiereIdAndDate(Long matiereId, Date date);
    List<Absence> findByMatiereMatiereId(Long matiereId);
   
}
