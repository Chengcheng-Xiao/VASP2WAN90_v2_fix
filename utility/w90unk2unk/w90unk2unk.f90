program w90unk2unk
implicit none

   integer :: ngx, ngy, ngz, nk, nbnd, I, ibnd,nx
   complex(kind=8), allocatable :: r_wvfn_nc(:, :, :)
   character*20 :: wfnname_in,wfnname_out

201   format ('UNK',i5.5,'.','NC')
202   format ('UNK',i5.5,'.','NC.formatted')

   ! read header
   open(3, file='UNK00001.NC', FORM='UNFORMATTED')
   read (1) ngx, ngy, ngz, nk, nbnd
   close(3)

   ! open file
   do I=1,nk
     write(wfnname_in,201) I
     open(1, file=wfnname_in, FORM='UNFORMATTED')

     read (1) ngx, ngy, ngz, nk, nbnd

     ! allocate array to store data
     allocate (r_wvfn_nc(ngx*ngy*ngz, nbnd, 2))

     ! read-in actual data
     do ibnd=1,nbnd
       !write(*,*) ibnd
       read(1) (r_wvfn_nc(nx, ibnd, 1), nx=1, ngx*ngy*ngz)
       read(1) (r_wvfn_nc(nx, ibnd, 2), nx=1, ngx*ngy*ngz)
     enddo
     close(1)

     ! get new file name (here, I choose to overwrite.)
     write(wfnname_out,201) I
     open(2, file=wfnname_out,FORM='FORMATTED')
     write(2,*) ngx, ngy, ngz, nk, nbnd
     do ibnd=1,nbnd
       !write(*,*) ibnd
       write(2,'(2ES20.10)') (r_wvfn_nc(nx, ibnd, 1), nx=1, ngx*ngy*ngz)
       write(2,'(2ES20.10)') (r_wvfn_nc(nx, ibnd, 2), nx=1, ngx*ngy*ngz)
     enddo
     close(2)
     deallocate (r_wvfn_nc)
     WRITE(*,*) "kpoint #", I, " done."
     ENDDO

end program w90unk2unk
